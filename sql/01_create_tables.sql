CREATE DATABASE IF NOT EXISTS payroll_analytics;
USE payroll_analytics;

CREATE TABLE employee_master (
    employee_id   INT PRIMARY KEY,
    name          VARCHAR(100),
    department    VARCHAR(50),
    location      VARCHAR(50),
    grade         VARCHAR(10),
    doj           DATE,
    status        VARCHAR(20)
);


