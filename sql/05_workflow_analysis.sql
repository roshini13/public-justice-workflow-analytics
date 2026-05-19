-- 1. Average processing time by region

SELECT
    region,
    ROUND(AVG(total_processing_days), 2) AS avg_processing_days,
    COUNT(case_id) AS total_cases
FROM case_workflow_summary
GROUP BY region
ORDER BY avg_processing_days DESC;


-- 2. Case backlog by status

SELECT
    current_status,
    COUNT(case_id) AS case_count
FROM case_workflow_summary
GROUP BY current_status
ORDER BY case_count DESC;


-- 3. High priority open cases

SELECT
    case_id,
    case_type,
    region,
    received_date,
    CURRENT_DATE - received_date AS days_open
FROM case_workflow_summary
WHERE current_status = 'Open'
  AND priority_level = 'High'
ORDER BY days_open DESC;


-- 4. Average workflow stage duration

SELECT
    workflow_stage,
    ROUND(AVG(stage_end_date - stage_start_date), 2) AS avg_stage_duration_days,
    COUNT(event_id) AS total_events
FROM workflow_events
WHERE stage_end_date IS NOT NULL
GROUP BY workflow_stage
ORDER BY avg_stage_duration_days DESC;


-- 5. Identify bottleneck stages using CTEs and ranking

WITH stage_durations AS (
    SELECT
        workflow_stage,
        AVG(stage_end_date - stage_start_date) AS avg_duration
    FROM workflow_events
    WHERE stage_end_date IS NOT NULL
    GROUP BY workflow_stage
),
ranked_stages AS (
    SELECT
        workflow_stage,
        avg_duration,
        RANK() OVER (ORDER BY avg_duration DESC) AS delay_rank
    FROM stage_durations
)
SELECT
    workflow_stage,
    ROUND(avg_duration, 2) AS avg_duration_days,
    delay_rank
FROM ranked_stages
ORDER BY delay_rank;


-- 6. Case volume by office type

SELECT
    office_type,
    COUNT(case_id) AS total_cases,
    ROUND(AVG(total_processing_days), 2) AS avg_processing_days
FROM case_workflow_summary
GROUP BY office_type
ORDER BY total_cases DESC;
