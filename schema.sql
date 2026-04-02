-- Core schema for staff, project, and allocation management

CREATE TABLE Rank (
    rank_id INT AUTO_INCREMENT PRIMARY KEY,
    rank_name VARCHAR(50) NOT NULL,
    base_salary DECIMAL(10, 2) NOT NULL
);

CREATE TABLE Specialization (
    specialization_id INT PRIMARY KEY,
    specialization_name VARCHAR(50) NOT NULL
);

CREATE TABLE Department (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    department_description TEXT,
    department_location VARCHAR(100),
    department_manager_id INT
);

CREATE TABLE staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialization_id INT,
    department_id INT,
    email VARCHAR(100) NOT NULL,
    rank_id INT,
    hire_date DATE,
    CONSTRAINT unique_email UNIQUE (email),
    CONSTRAINT fk_staff_specialization
        FOREIGN KEY (specialization_id) REFERENCES Specialization(specialization_id),
    CONSTRAINT fk_staff_department
        FOREIGN KEY (department_id) REFERENCES Department(department_id),
    CONSTRAINT fk_staff_rank
        FOREIGN KEY (rank_id) REFERENCES Rank(rank_id)
);

-- Add manager foreign key after staff table creation to avoid circular dependency
ALTER TABLE Department
ADD CONSTRAINT fk_department_manager
FOREIGN KEY (department_manager_id) REFERENCES staff(staff_id);

CREATE TABLE project (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    project_name VARCHAR(100),
    start_date DATE,
    end_date DATE,
    project_status VARCHAR(50),
    project_bonus DECIMAL(10, 2),
    project_level INT
);

CREATE TABLE project_assignment (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    staff_id INT NOT NULL,
    specialization_id INT NOT NULL,
    role_in_project VARCHAR(50),
    CONSTRAINT fk_assignment_project
        FOREIGN KEY (project_id) REFERENCES project(project_id),
    CONSTRAINT fk_assignment_staff
        FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
    CONSTRAINT fk_assignment_specialization
        FOREIGN KEY (specialization_id) REFERENCES Specialization(specialization_id)
);

CREATE TABLE borrowing_log (
    borrowing_id INT AUTO_INCREMENT PRIMARY KEY,
    staff_id INT NOT NULL,
    from_department_id INT,
    to_department_id INT,
    project_id INT,
    start_date DATE NOT NULL,
    end_date DATE DEFAULT NULL,
    role VARCHAR(255),
    reason TEXT,
    CONSTRAINT fk_borrow_staff
        FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
    CONSTRAINT fk_borrow_from_department
        FOREIGN KEY (from_department_id) REFERENCES Department(department_id),
    CONSTRAINT fk_borrow_to_department
        FOREIGN KEY (to_department_id) REFERENCES Department(department_id),
    CONSTRAINT fk_borrow_project
        FOREIGN KEY (project_id) REFERENCES project(project_id)
);

CREATE TABLE ProjectStatusLog (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    old_status VARCHAR(50),
    new_status VARCHAR(50),
    change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_statuslog_project
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
