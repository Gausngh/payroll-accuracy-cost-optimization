# Power BI Data Model – Payroll Accuracy & Cost Optimization

## Fact table
- `monthly_payroll`
  - Grain: one row per employee per month (`employee_id`, `month_start`).
  - Key fields: employee attributes (department, location, grade, status) and payroll metrics (base_pay, overtime_pay, gross_pay, net_pay, tax, pf, esi, other_deductions).

## Core measures (DAX)
- `Total Net Pay` = SUM ( monthly_payroll[net_pay] )
- `Total Gross Pay` = SUM ( monthly_payroll[gross_pay] )
- `Total Overtime Pay` = SUM ( monthly_payroll[overtime_pay] )
- `Total Deductions` = SUM ( monthly_payroll[tax] ) + ...
- `Headcount` = DISTINCTCOUNT ( monthly_payroll[employee_id] )
- `Net Pay per Employee` = DIVIDE ( [Total Net Pay], [Headcount] )
- `Overtime % of Gross` = DIVIDE ( [Total Overtime Pay], [Total Gross Pay] )
- `Deductions % of Gross` = DIVIDE ( [Total Deductions], [Total Gross Pay] )
- `Net Pay Previous Month` = CALCULATE ( [Total Net Pay], DATEADD ( monthly_payroll[month_start], -1, MONTH ) )
- `Net Pay MoM %` = DIVIDE ( [Net Pay MoM Change], [Net Pay Previous Month] )
