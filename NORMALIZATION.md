# Database Normalization Report: Construction Institute System

This document outlines the step-by-step normalization process of the Construction Institute Management System, transforming the schema from **Unnormalized Form (UNF)** to **Third Normal Form (3NF)** to ensure data integrity and eliminate anomalies.

---

## 1. Staff Information Module 

* **UNF:** `(Staff ID, Name, Specialization ID, Specialization Name, Department ID, Department Name, Department Location, Email, Rank ID, Rank Name, Base Salary, Hire date)`
* **Functional Dependencies (FDs):**
    * `Staff ID` → `Name`, `Specialization ID`, `Department ID`, `Email`, `Rank ID`, `Hire date` (Primary Key)
    * `Specialization ID` → `Specialization Name` (Transitive Dependency)
    * `Department ID` → `Department Name`, `Department Location` (Transitive Dependency)
    * `Rank ID` → `Rank Name`, `Base Salary` (Transitive Dependency)
* **Normalization Steps:**
    * **1NF:** All attributes are atomic; `Staff ID` is defined as the Primary Key.
    * **2NF:** No partial dependencies exist as the PK is a single attribute.
    * **3NF:** Removed transitive dependencies by decomposing the staff entity into four specialized tables.
* **Final 3NF Schema:**
    1.  **Staff**: (`Staff ID`, `Name`, `Specialization ID`, `Department ID`, `Email`, `Rank ID`, `Hire date`)
    2.  **Specialization**: (`Specialization ID`, `Specialization Name`)
    3.  **Department**: (`Department ID`, `Department Name`, `Department Location`)
    4.  **Rank**: (`Rank ID`, `Rank Name`, `Base Salary`)

---

## 2. Project & Resource Allocation 

* **UNF:** `(Project ID, Project Name, Start Date, End Date, Project Status, Project Bonus, Project Level, Staff ID, Role, Specialization, Status)`
* **Functional Dependencies (FDs):**
    * `Project ID` → `Project Name`, `Start Date`, `End Date`, `Project Status`, `Project Bonus`, `Project Level`
    * `{Project ID, Staff ID}` → `Role`, `Specialization` (Composite Key)
* **Normalization Result (3NF):**
    1.  **Project**: (`Project ID`, `Project Name`, `Start Date`, `End Date`, `Project Status`, `Project Bonus`, `Project Level`)
    2.  **Assignment**: (`Assignment ID`, `Staff ID`, `Project ID`, `Role_in_Project`, `Specialization ID`)
    3.  **Specialization**: (`Specialization ID`, `Specialization Name`)
    * *Note: An **Assignment** junction table was implemented to resolve the Many-to-Many relationship between Staff and Projects.*

---

## 3. Major Coefficients 

* **Functional Dependency:** `Major Number` → `Major Name`, `Coefficient`
* **Final 3NF Schema:**
    * **Major_Coefficients**: (`Major Number`, `Major Name`, `Coefficient`)
    * *Note: This table acts as a reference for calculating individual bonuses based on project totals.*

---

## 4. Administrative Logs 

### 4.1 Leave Requests 
* **FD:** `Leave ID` → `Staff ID`, `Start Date`, `End Date`, `Leave Reason`, `Leave Status`
* **3NF Schema:** `Leave_Request`: (`Leave ID`, `Staff ID`, `Start Date`, `End Date`, `Leave Reason`, `Leave Status`)

### 4.2 Staff Borrowing Log 
* **UNF:** `(Borrowing ID, Staff ID, From Department ID, To Department ID, Project ID, Start Date, End Date, Role, Reason)`
* **Analysis:** While `From/To Department ID` points to the Department table, the log captures the historical state of staff movements across departments.
* **3NF Schema:** `Borrowing_Log`: (`Borrowing ID`, `Staff ID`, `From Department ID`, `To Department ID`, `Project ID`, `Start Date`, `End Date`, `Role`, `Reason`)

---

## 5. Payroll & Compensation Architecture 

* **UNF:** `(Payroll ID, Staff ID, Department ID, Base Salary, Bonus, Deductions, Net Salary, Pay Date)`
* **Functional Dependencies (FDs):**
    * `Payroll ID` → `Staff ID`, `Department ID`, `Base Salary`, `Bonus`, `Deductions`, `Net Salary`, `Pay Date`
    * `Staff ID` → `Department ID`, `Base Salary`
* **Normalization Strategy:**
    * **3NF Refinement:** Identified that `Base Salary` is functionally dependent on `Staff ID` (via their Rank).
    * **Action:** Moved `Base Salary` to the **Staff/Rank** tables to maintain the **Single Version of Truth (SVOT)**. The Payroll table now exclusively stores variable transaction data.
* **Final 3NF Schema:**
    * **Payroll**: (`Payroll ID`, `Staff ID`, `Bonus`, `Deductions`, `Net Salary`, `Pay Date`)

---

## Summary of Improvements
1.  **Redundancy Elimination:** Removed repetitive department and rank data, significantly reducing storage and potential for data inconsistency.
2.  **Anomaly Prevention:** Ensured that updating a department's location or a specialization's coefficient requires only a single record update.
3.  **Logical Integrity:** Implemented foreign key constraints across all 3NF tables to maintain referential integrity.
