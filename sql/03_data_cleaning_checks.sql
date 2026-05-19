-- 1. Check for cases where the closed date is before the received date

SELECT
    case_id,
    received_date,
    closed_date
FROM cases
WHERE closed_date < received_date;


-- 2. Check for duplicate case records

SELECT
    case_id,
    COUNT(*) AS duplicate_count
FROM cases
GROUP BY case_id
HAVING COUNT(*) > 1;


-- 3. Check for workflow events that do not match a valid case

SELECT
    we.event_id,
    we.case_id
FROM workflow_events we
LEFT JOIN cases c
    ON we.case_id = c.case_id
WHERE c.case_id IS NULL;


-- 4. Check for workflow stages where the end date is before the start date

SELECT
    event_id,
    case_id,
    workflow_stage,
    stage_start_date,
    stage_end_date
FROM workflow_events
WHERE stage_end_date < stage_start_date;


-- 5. Check for missing required case fields

SELECT
    case_id,
    case_type,
    received_date,
    current_status,
    location_id
FROM cases
WHERE case_id IS NULL
   OR case_type IS NULL
   OR received_date IS NULL
   OR current_status IS NULL
   OR location_id IS NULL;


-- 6. Check for open cases with unusually long processing time

SELECT
    case_id,
    case_type,
    received_date,
    current_status,
    CURRENT_DATE - received_date AS days_open
FROM cases
WHERE current_status = 'Open'
  AND CURRENT_DATE - received_date > 90
ORDER BY days_open DESC;
