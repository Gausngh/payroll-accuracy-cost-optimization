LOAD DATA LOCAL INFILE 'C:/path/to/deductions.csv'
INTO TABLE deductions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(employee_id, @csv_month, tax, pf, esi, other_deductions)
SET month = STR_TO_DATE(CONCAT(@csv_month, '-01'), '%Y-%m-%d');
