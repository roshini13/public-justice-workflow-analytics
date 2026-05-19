# Data Dictionary

This document describes the synthetic data tables used in the Public Justice Workflow Analytics project.

## Table: cases

| Column | Description |
|---|---|
| case_id | Synthetic unique identifier for each case |
| case_type | Mock category of workflow case |
| received_date | Date the case entered the workflow |
| closed_date | Date the case was completed, if applicable |
| current_status | Current workflow status such as Open, Closed, or Pending Review |
| location_id | Synthetic location identifier connected to the locations table |
| priority_level | Mock priority classification such as Low, Standard, or High |

## Table: workflow_events

| Column | Description |
|---|---|
| event_id | Synthetic unique identifier for each workflow event |
| case_id | Case connected to the workflow event |
| workflow_stage | Stage of the workflow process |
| stage_start_date | Date the workflow stage began |
| stage_end_date | Date the workflow stage ended, if completed |
| assigned_unit | Mock unit responsible for the workflow stage |

## Table: locations

| Column | Description |
|---|---|
| location_id | Synthetic unique identifier for each location |
| region | Mock geographic region |
| office_type | Mock office classification |

## Table: staff_assignments

| Column | Description |
|---|---|
| assignment_id | Synthetic unique identifier for each assignment |
| case_id | Case connected to the assignment |
| role_type | Mock staff role category |
| assigned_date | Date the assignment began |
