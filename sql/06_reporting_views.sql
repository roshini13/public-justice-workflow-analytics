-- View 1: Case backlog summary by region, case type, and status

CREATE VIEW vw_case_backlog_summary AS
SELECT
    region,
    case_type,
    current_status,
    COUNT(case_id) AS total_cases,
    ROUND(AVG(total_processing_days), 2) AS avg_processing_days
FROM case_workflow_summary
GROUP BY
    region,
    case_type,
    current_status;


-- View 2: Workflow stage bottleneck summary

CREATE VIEW vw_stage_bottleneck_summary AS
SELECT
    workflow_stage,
    COUNT(event_id) AS total_stage_events,
    ROUND(AVG(stage_end_date - stage_start_date), 2) AS avg_stage_duration_days
FROM workflow_events
WHERE stage_end_date IS NOT NULL
GROUP BY workflow_stage;


-- View 3: High priority open case summary

CREATE VIEW vw_high_priority_open_cases AS
SELECT
    case_id,
    case_type,
    region,
    office_type,
    received_date,
    CURRENT_DATE - received_date AS days_open,
    priority_level,
    current_status
FROM case_workflow_summary
WHERE current_status = 'Open'
  AND priority_level = 'High';


-- View 4: Regional throughput summary

CREATE VIEW vw_regional_throughput_summary AS
SELECT
    region,
    COUNT(case_id) AS total_cases,
    COUNT(CASE WHEN current_status = 'Closed' THEN 1 END) AS closed_cases,
    COUNT(CASE WHEN current_status <> 'Closed' THEN 1 END) AS open_or_pending_cases,
    ROUND(AVG(total_processing_days), 2) AS avg_processing_days
FROM case_workflow_summary
GROUP BY region;
