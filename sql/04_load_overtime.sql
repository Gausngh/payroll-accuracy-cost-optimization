USE payroll_analytics;

LOAD DATA LOCAL INFILE 'C:/Users/YourName/Documents/payroll-accuracy-cost-optimization/data_raw/overtime.csv'
INTO TABLE overtime
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(employee_id, date, overtime_hours, overtime_type);
