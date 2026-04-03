# Data Integrity & Resource Allocation Analysis (MySQL)

## Overview
This project focuses on data validation, data integrity enforcement, and discrepancy analysis within a construction institute's staff and project management system.

The goal is to ensure accurate resource allocation, prevent data inconsistencies, and support operational decision-making using SQL.

---

## Key Contributions
- **Schema Design & Normalization:** Engineered a relational database from scratch, applying **3NF normalization** to support complex construction institute operations (6 departments, multiple specializations).
- **Advanced Data Integrity:** Implemented **Triggers and Constraints** to automate business rule enforcement, such as rank-based project assignment and automated salary/bonus calculations.
- **Complex Analytical Queries:** Developed multi-table JOINs and subqueries to perform **Discrepancy Analysis**, identifying resource overallocation and cross-department staffing gaps.
- **Audit & Logging:** Designed an automated logging system using Triggers to track project status transitions, ensuring a full audit trail for project lifecycles.

---

## Example Analysis
This project includes multiple real-world data validation scenarios:

- Detecting overloaded staff assigned to multiple active projects
- Identifying inconsistencies in department staff counts due to cross-department borrowing
- Validating leave approval rules based on workload and project level
- Tracking project status changes using triggers and log tables

---

## Tech Stack
- MySQL
- SQL (JOIN, GROUP BY, aggregation, views)
- Relational Database Design

---

## Project Structure (to be updated)
- schema.sql: table creation and constraints
- queries.sql: analysis and validation queries
- docs/: additional notes and explanations
