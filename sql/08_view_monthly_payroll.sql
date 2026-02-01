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
    (a.total_shift_hours * 500) AS base_pay,
    (a.total_overtime_hours * 500 * 1.5) AS overtime_pay,
    (a.total_shift_hours * 500) + (a.total_overtime_hours * 500 * 1.5) AS gross_pay,
    ( (a.total_shift_hours * 500) + (a.total_overtime_hours * 500 * 1.5)
      - (COALESCE(d.tax, 0) + COALESCE(d.pf, 0) + COALESCE(d.esi, 0) + COALESCE(d.other_deductions, 0))
    ) AS net_pay
FROM vw_monthly_attendance_overtime a
LEFT JOIN vw_monthly_deductions d
    ON a.employee_id = d.employee_id
   AND a.month_start = d.month_start;
