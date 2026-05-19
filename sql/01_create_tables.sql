CREATE TABLE locations (
    location_id VARCHAR(10) PRIMARY KEY,
    region VARCHAR(50),
    office_type VARCHAR(50)
);

CREATE TABLE cases (
    case_id VARCHAR(20) PRIMARY KEY,
    case_type VARCHAR(100),
    received_date DATE,
    closed_date DATE,
    current_status VARCHAR(50),
    location_id VARCHAR(10),
    priority_level VARCHAR(50),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE TABLE workflow_events (
    event_id VARCHAR(20) PRIMARY KEY,
    case_id VARCHAR(20),
    workflow_stage VARCHAR(100),
    stage_start_date DATE,
    stage_end_date DATE,
    assigned_unit VARCHAR(100),
    FOREIGN KEY (case_id) REFERENCES cases(case_id)
);

CREATE TABLE staff_assignments (
    assignment_id VARCHAR(20) PRIMARY KEY,
    case_id VARCHAR(20),
    role_type VARCHAR(100),
    assigned_date DATE,
    FOREIGN KEY (case_id) REFERENCES cases(case_id)
);
