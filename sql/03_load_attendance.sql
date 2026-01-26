USE payroll_analytics;

-- Enable LOCAL INFILE on the server (run once per restart if needed)
SET GLOBAL local_infile = 1;

-- Verify setting
SHOW GLOBAL VARIABLES LIKE 'local_infile';

-- Bulk-load attendance data
LOAD DATA LOCAL INFILE 'C:/Users/YourName/Documents/payroll-accuracy-cost-optimization/data_raw/attendance.csv'
INTO TABLE attendance
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;