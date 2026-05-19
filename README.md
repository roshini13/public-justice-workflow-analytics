# Public Justice Workflow Analytics

## Project Overview

This project is a PostgreSQL analytics project designed to evaluate workflow throughput, case processing timelines, backlog patterns, and operational bottlenecks in a simulated public justice case management environment.

The project uses fully synthetic data and does not include any real agency, court, law enforcement, criminal justice, confidential, or personally identifiable information. The purpose of this repository is to demonstrate SQL data modeling, ETL design, data quality validation, and operational reporting using a realistic public sector analytics scenario.

## Business Context

Public sector agencies often manage large volumes of operational records that move through multiple workflow stages before completion. Delays can happen at different points in the process, such as intake, documentation review, supervisor review, or final decision.

This project simulates that type of workflow environment and answers questions such as:

1. Which workflow stages have the longest average processing time?
2. Which regions show higher backlog levels?
3. How many high priority cases remain open?
4. Are there invalid or incomplete records affecting reporting reliability?
5. How can cleaned workflow data support operational decision making?

## Data Privacy Statement

This project uses only synthetic mock data. No real public justice records, state agency data, case information, staff information, or personally identifiable information is included.

All case identifiers, dates, locations, workflow stages, and assignments were created only for portfolio demonstration purposes.

## Tools Used

1. PostgreSQL
2. SQL
3. GitHub
4. CSV mock data
5. Relational data modeling
6. ETL transformation logic

## Repository Structure

```text
data/
Contains synthetic CSV files used for loading mock case and workflow data.

sql/
Contains SQL scripts for table creation, data loading, data cleaning checks, transformations, workflow analysis, and reporting views.

docs/
Contains the data dictionary, methodology notes, and project assumptions.

outputs/
Contains sample reporting outputs generated from the SQL analysis.
