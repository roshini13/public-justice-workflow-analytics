# Methodology

This project follows a structured SQL based analytics workflow using synthetic public justice workflow data.

## 1. Data Generation

Synthetic case records were created to simulate a public justice workflow environment. The mock data includes case dates, workflow stages, priority levels, locations, and assignment records.

No real agency records, case data, confidential information, or personally identifiable information is used.

## 2. Data Loading

CSV files are loaded into PostgreSQL tables using SQL scripts. The database structure includes primary and foreign keys to maintain relationships between case records, workflow events, locations, and staff assignments.

## 3. Data Quality Review

Before analysis, data quality checks are performed to identify possible reporting issues, including:

1. Duplicate case records
2. Invalid date sequences
3. Missing required fields
4. Orphan workflow events
5. Workflow stages with incomplete dates
6. Open cases with long processing times

## 4. Transformation

Cleaned records are transformed into an analysis ready summary table called `case_workflow_summary`.

This table combines case information, location details, workflow event counts, processing duration, and status indicators.

## 5. Analysis

SQL queries are used to evaluate workflow throughput, backlog patterns, stage delays, and high priority open cases.

The analysis uses joins, aggregations, date calculations, Common Table Expressions, and window functions.

## 6. Reporting

Reusable SQL views are created to support summary reporting. These views can later support dashboards or recurring operational reports.
