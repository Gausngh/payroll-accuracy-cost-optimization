USE payroll_analytics;

CREATE OR REPLACE VIEW vw_monthly_attendance_overtime AS
SELECT
    e.employee_id,
    e.name,
    e.department,
    e.location,
    e.grade,
    e.status,
    DATE_FORMAT(a.date, '%Y-%m-01') AS month_start,

    -- Attendance metrics
    COUNT(*) AS total_days,  -- number of records in attendance table
    SUM(a.shift_hours) AS total_shift_hours,
    SUM(a.unpaid_leave_hours) AS total_unpaid_leave_hours,
    SUM(a.paid_leave_hours) AS total_paid_leave_hours,

    -- Overtime metrics (joined by date)
    COALESCE(SUM(o.overtime_hours), 0) AS total_overtime_hours
FROM employee_master e
JOIN attendance a
    ON e.employee_id = a.employee_id
LEFT JOIN overtime o
    ON e.employee_id = o.employee_id
   AND a.date = o.date
GROUP BY
    e.employee_id,
    e.name,
    e.department,
    e.location,
    e.grade,
    e.status,
    month_start;
