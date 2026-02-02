# Payroll Accuracy & Cost Optimization

End‑to‑end payroll analytics project to monitor payroll costs, overtime, and payroll error candidates using synthetic data.

**Tech stack:** Python (data generation, checks), MySQL (SQL views & KPIs), Power BI (dashboards).

## Business Problem & Insights

**Business problem.** Payroll teams need to ensure employees are paid accurately while keeping overtime and deductions under control at department and location level.

**Goal.** Build a repeatable analytics pipeline that highlights payroll accuracy risks and cost optimization opportunities by employee, month, and department.[web:92][web:98]

**Approach.**
- Generate realistic synthetic payroll data with Python.
- Load and aggregate data in MySQL, using materialized monthly tables for performance.
- Build a Power BI model on `monthly_payroll` with DAX measures for net pay, overtime %, deductions %, headcount, and month-over-month changes.

**Key insights this report can surface.**
- Which departments have the highest total payroll cost and highest **net pay per employee**.
- Where **overtime % of gross** is unusually high, signalling potential scheduling or staffing issues.
- How **net pay** and headcount are trending over months, and whether recent changes increased or reduced payroll cost.
- The impact of deductions (tax, PF, ESI, others) as a share of gross pay across departments and locations.

**Potential business actions.**
- Rebalance staffing in departments with persistently high overtime.
- Review deduction policies and communication where deductions % is out-of-line.
- Use month-over-month trends to budget payroll more accurately and flag anomalies early.

## End-to-End Pipeline

This project simulates and analyzes payroll data across the full stack: **Python → MySQL → materialized tables → Power BI**.[web:74][web:85]

### 1. Data generation (Python)

- Script: `data_raw/generate_payroll_data.py`
- Generates synthetic HR + payroll CSVs:
  - `employee_master.csv`
  - `attendance.csv`
  - `overtime.csv`
  - `deductions.csv`
  - `tax_slabs.csv` (reserved for future tax logic)
- Each run can refresh the raw dataset for new scenarios.

### 2. Database & staging (MySQL)

- Database: `payroll_analytics`
- Core tables loaded from CSV using SQL scripts in `sql/`:
  - `02_load_data.sql` → `employee_master`
  - `03_load_attendance.sql` → `attendance`
  - `04_load_overtime.sql` → `overtime`
  - `05_load_deductions.sql` → `deductions`
- Indexes on `(employee_id, date/month)` support fast joins on daily and monthly grain.

### 3. Materialized monthly tables (MySQL)

- `09_build_monthly_tables.sql` precomputes monthly aggregates to avoid heavy views.
- Tables:
  - `monthly_attendance_overtime`  
    - Grain: one row per employee per month with total shift hours, leave, overtime.
  - `monthly_payroll`  
    - Grain: one row per employee per month with:
      - Attendance + overtime metrics
      - Deductions (tax, PF, ESI, others)
      - Calculated `base_pay`, `overtime_pay`, `gross_pay`, `net_pay` using a simple rate model.
- These tables act as the **fact layer** for BI tools.

### 4. Analytics layer (Power BI)

- Data source: MySQL (`localhost`, DB `payroll_analytics`, table `monthly_payroll`).
- Data model:
  - Single fact table `monthly_payroll` at employee–month grain.
  - DAX measures defined for:
    - Total and average net/gross pay
    - Overtime and deductions as % of gross
    - Headcount by month/department
    - Month-over-month net pay change
- Dashboards:
  - **Payroll Overview**: top-line KPIs, trend over time, and month slicer.
  - **Department Payroll**: net pay, per-employee cost, overtime %, and deductions % by department.

## Documentation

- [Progress log](docs/progress_log.md): chronological steps, design decisions, and learnings.
- [Power BI data model & measures](docs/powerbi_data_model.md): fact table grain and all DAX measures used in the reports.

## Dashboard Screenshots

### Payroll Overview

![Payroll Overview](screenshots/payroll_overview.png)

### Department Payroll

![Department Payroll](screenshots/department_payroll.png)

## How to Run This Project

1. **Clone the repo**
   ```bash
   git clone https://github.com/<your-username>/payroll-accuracy-cost-optimization.git
   cd payroll-accuracy-cost-optimization
Generate data (Python)

Ensure Python is installed.

Install any required packages (see comments in data_raw/generate_payroll_data.py if applicable).

Run:

bash
python data_raw/generate_payroll_data.py
Load data into MySQL

Create DB payroll_analytics in MySQL.

Run the SQL scripts in sql/ in order:

02_load_data.sql

03_load_attendance.sql

04_load_overtime.sql

05_load_deductions.sql

09_build_monthly_tables.sql

Open the Power BI report

Open payroll_analytics.pbix in Power BI Desktop.

Update the MySQL connection if needed (Server: localhost, Database: payroll_analytics).

Refresh the report to load the latest data.
