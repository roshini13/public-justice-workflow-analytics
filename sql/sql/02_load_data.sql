COPY locations(location_id, region, office_type)
FROM 'data/synthetic_locations.csv'
DELIMITER ','
CSV HEADER;

COPY cases(case_id, case_type, received_date, closed_date, current_status, location_id, priority_level)
FROM 'data/synthetic_cases.csv'
DELIMITER ','
CSV HEADER;

COPY workflow_events(event_id, case_id, workflow_stage, stage_start_date, stage_end_date, assigned_unit)
FROM 'data/synthetic_events.csv'
DELIMITER ','
CSV HEADER;

COPY staff_assignments(assignment_id, case_id, role_type, assigned_date)
FROM 'data/synthetic_staff_assignments.csv'
DELIMITER ','
CSV HEADER;
