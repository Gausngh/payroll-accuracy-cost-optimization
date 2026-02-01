DROP TABLE IF EXISTS monthly_payroll;

CREATE TABLE monthly_payroll (
    employee_id                 INT,
    name                        VARCHAR(255),
    department                  VARCHAR(255),
    location                    VARCHAR(255),
    grade                       VARCHAR(50),
    status                      VARCHAR(50),
    month_start                 DATE,

    total_days                  INT,
    total_shift_hours           DECIMAL(10,2),
    total_unpaid_leave_hours    DECIMAL(10,2),
    total_paid_leave_hours      DECIMAL(10,2),
    total_overtime_hours        DECIMAL(10,2),

    tax                         DECIMAL(10,2),
    pf                          DECIMAL(10,2),
    esi                         DECIMAL(10,2),
    other_deductions            DECIMAL(10,2),

    base_pay                    DECIMAL(12,2),
    overtime_pay                DECIMAL(12,2),
    gross_pay                   DECIMAL(12,2),
    net_pay                     DECIMAL(12,2),

    PRIMARY KEY (employee_id, month_start)
);


INSERT INTO monthly_payroll (
    employee_id,
    name,
    department,
    location,
    grade,
    status,
    month_start,
    total_days,
    total_shift_hours,
    total_unpaid_leave_hours,
    total_paid_leave_hours,
    total_overtime_hours,
    tax,
    pf,
    esi,
    other_deductions,
    base_pay,
    overtime_pay,
    gross_pay,
    net_pay
)
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
    COALESCE(d.other_deductions, 0) AS other_deductions,
    (a.total_shift_hours * 500) AS base_pay,
    (a.total_overtime_hours * 500 * 1.5) AS overtime_pay,
    (a.total_shift_hours * 500) + (a.total_overtime_hours * 500 * 1.5) AS gross_pay,
    ( (a.total_shift_hours * 500) + (a.total_overtime_hours * 500 * 1.5)
      - (COALESCE(d.tax, 0) + COALESCE(d.pf, 0) + COALESCE(d.esi, 0) + COALESCE(d.other_deductions, 0))
    ) AS net_pay
FROM monthly_attendance_overtime a
LEFT JOIN deductions d
    ON a.employee_id = d.employee_id
   AND a.month_start = d.month;
