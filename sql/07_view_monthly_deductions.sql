USE payroll_analytics;

CREATE OR REPLACE VIEW vw_monthly_deductions AS
SELECT
    employee_id,
    month AS month_start,
    tax,
    pf,
    esi,
    other_deductions
FROM deductions;
