
-- DESCRIPTION:
-- Builds an analysis-ready workflow summary table from synthetic case,
-- workflow, and location data. Includes reproducible ETL logic, indexes,
-- stage duration analysis, and data quality audit views.

-- STEP 1: BASE ETL - SUMMARY TABLE GENERATION

-- Creates an analysis-ready reporting table combining case details, regional
-- data, workflow event counts, and total lifecycle duration.


DROP TABLE IF EXISTS case_workflow_summary;

CREATE TABLE case_workflow_summary AS
SELECT
    c.case_id,
    c.case_type,
    c.received_date,
    c.closed_date,
    c.current_status,
    c.priority_level,
    l.region,
    l.office_type,
    COUNT(we.event_id) AS total_workflow_events,
    MIN(we.stage_start_date) AS first_stage_start_date,
    MAX(we.stage_end_date) AS last_stage_end_date,
    CASE
        WHEN c.closed_date IS NOT NULL
            THEN c.closed_date - c.received_date
        ELSE CURRENT_DATE - c.received_date
    END AS total_processing_days
FROM cases c
LEFT JOIN workflow_events we
    ON c.case_id = we.case_id
LEFT JOIN locations l
    ON c.location_id = l.location_id
GROUP BY
    c.case_id,
    c.case_type,
    c.received_date,
    c.closed_date,
    c.current_status,
    c.priority_level,
    l.region,
    l.office_type;


-- STEP 2: INDEXES FOR DOWNSTREAM ANALYSIS
-- Adds indexes to improve filtering and grouped reporting performance.

CREATE INDEX idx_summary_case_type
ON case_workflow_summary(case_type);

CREATE INDEX idx_summary_region
ON case_workflow_summary(region);

CREATE INDEX idx_summary_status
ON case_workflow_summary(current_status);


-- STEP 3: STAGE DURATION AND BOTTLENECK ANALYSIS
-- Uses CTEs and window functions to evaluate time spent in each workflow stage.


CREATE OR REPLACE VIEW v_workflow_stage_duration_analysis AS
WITH stage_lag_calculations AS (
    SELECT
        case_id,
        workflow_stage,
        stage_start_date,
        stage_end_date,
        COALESCE(stage_end_date - stage_start_date, CURRENT_DATE - stage_start_date) AS days_in_stage,
        ROW_NUMBER() OVER (
            PARTITION BY case_id
            ORDER BY stage_start_date ASC
        ) AS stage_sequence_number
    FROM workflow_events
)
SELECT
    workflow_stage,
    COUNT(case_id) AS total_cases_processed,
    ROUND(AVG(days_in_stage), 1) AS average_days_in_stage,
    MIN(days_in_stage) AS min_days_in_stage,
    MAX(days_in_stage) AS max_days_in_stage,
    CASE
        WHEN AVG(days_in_stage) > 14 THEN 'High Bottleneck Risk'
        ELSE 'Within Expected Range'
    END AS operational_status
FROM stage_lag_calculations
GROUP BY workflow_stage;

-- STEP 4: DATA QUALITY AUDIT LOG
-- Flags dirty, incomplete, or logically inconsistent records before reporting.

CREATE OR REPLACE VIEW v_data_quality_audit_log AS

SELECT
    c.case_id,
    c.received_date AS issue_start_date,
    c.closed_date AS issue_end_date,
    'Logical Date Violation' AS anomaly_type,
    'The closed_date occurs before the received_date.' AS remediation_guidance
FROM cases c
WHERE c.closed_date < c.received_date

UNION ALL

SELECT
    c.case_id,
    c.received_date AS issue_start_date,
    c.closed_date AS issue_end_date,
    'Missing Location Reference' AS anomaly_type,
    'The case contains a location_id that does not exist in the locations table.' AS remediation_guidance
FROM cases c
LEFT JOIN locations l
    ON c.location_id = l.location_id
WHERE l.location_id IS NULL

UNION ALL

SELECT
    c.case_id,
    c.received_date AS issue_start_date,
    c.closed_date AS issue_end_date,
    'Missing Workflow Events' AS anomaly_type,
    'The case exists but does not have any related workflow event records.' AS remediation_guidance
FROM cases c
LEFT JOIN workflow_events we
    ON c.case_id = we.case_id
WHERE we.event_id IS NULL

UNION ALL

SELECT
    we.case_id,
    we.stage_start_date AS issue_start_date,
    we.stage_end_date AS issue_end_date,
    'Negative Stage Duration' AS anomaly_type,
    'The workflow event ends before its recorded start date.' AS remediation_guidance
FROM workflow_events we
WHERE we.stage_end_date < we.stage_start_date;


-- STEP 5: DIAGNOSTIC PREVIEWS
-- Verification queries for reviewing transformed outputs and data quality status.


SELECT *
FROM case_workflow_summary
LIMIT 10;

SELECT *
FROM v_workflow_stage_duration_analysis
ORDER BY average_days_in_stage DESC;

SELECT
    anomaly_type,
    COUNT(*) AS total_occurrences
FROM v_data_quality_audit_log
GROUP BY anomaly_type;
