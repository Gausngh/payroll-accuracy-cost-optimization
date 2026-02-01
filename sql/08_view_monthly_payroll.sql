USE payroll_analytics;

CREATE OR REPLACE VIEW vw_monthly_payroll AS
SELECT
    a.employee_id,
    a.name,
    a.department,
    a.location,
    a.grade,
    a.status,
    a.month_start,

    a.total_days,
    a.total_shift_hours,
    a.total_unpaid_leave_hours,
    a.total_paid_leave_hours,
    a.total_overtime_hours,

    COALESCE(d.tax, 0)              AS tax,
    COALESCE(d.pf, 0)               AS pf,
    COALESCE(d.esi, 0)              AS esi,
    COALESCE(d.other_deductions, 0) AS other_deductions
FROM vw_monthly_attendance_overtime a
LEFT JOIN vw_monthly_deductions d
    ON a.employee_id = d.employee_id
   AND a.month_start = d.month_start;
