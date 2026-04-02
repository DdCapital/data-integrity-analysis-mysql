-- Query 1: Track project status changes
-- Purpose: Preserve project status history for audit and monitoring

CREATE TABLE ProjectStatusLog (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    old_status VARCHAR(50),
    new_status VARCHAR(50),
    change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES project(project_id)
);

DELIMITER $$
CREATE TRIGGER after_project_status_update
AFTER UPDATE ON project
FOR EACH ROW
BEGIN
    IF OLD.project_status != NEW.project_status THEN
        INSERT INTO ProjectStatusLog (project_id, old_status, new_status)
        VALUES (OLD.project_id, OLD.project_status, NEW.project_status);
    END IF;
END $$
DELIMITER ;

SELECT * FROM ProjectStatusLog;


-- Query 2: Count in-progress high-level projects for a staff member
-- Purpose: Support leave approval validation based on workload

SELECT
    COUNT(p.project_id) AS in_progress_high_level_projects
FROM project_assignment pa
JOIN project p ON pa.project_id = p.project_id
JOIN staff s ON pa.staff_id = s.staff_id
WHERE s.name = 'John Carter'
  AND p.project_status = 'In Progress'
  AND p.project_level > 2;


-- Query 3: Create a view for high-level project assignments
-- Purpose: Identify staff assigned to level-5 projects

CREATE VIEW high_level_project_assignment AS
SELECT
    s.staff_id,
    s.name AS staff_name,
    p.project_id,
    p.project_name,
    p.project_level,
    pa.role_in_project
FROM project p
JOIN project_assignment pa ON p.project_id = pa.project_id
JOIN staff s ON pa.staff_id = s.staff_id
WHERE p.project_level = 5;

SELECT * FROM high_level_project_assignment;


-- Query 4: Calculate individual bonuses for completed projects
-- Purpose: Allocate project bonuses by specialization coefficient

SELECT
    pa.staff_id,
    s.name AS staff_name,
    mc.major_name,
    p.project_bonus,
    mc.coefficient,
    (p.project_bonus * mc.coefficient) AS individual_bonus
FROM project_assignment pa
JOIN staff s ON pa.staff_id = s.staff_id
JOIN Specialization sp ON pa.specialization_id = sp.specialization_id
JOIN Major_Coefficients mc ON sp.specialization_name = mc.major_name
JOIN project p ON pa.project_id = p.project_id
WHERE p.project_status = 'Completed';
