USE payroll_analytics;

LOAD DATA LOCAL INFILE 'C:/Users/YourName/Documents/payroll-accuracy-cost-optimization/data_raw/employee_master.csv'
INTO TABLE employee_master
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(employee_id, name, department, location, grade, doj, status);