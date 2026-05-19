-- Create an analysis ready table that combines case details,
-- location details, workflow activity, and processing time calculations.

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


-- Preview the transformed summary table.

SELECT *
FROM case_workflow_summary
LIMIT 20;
