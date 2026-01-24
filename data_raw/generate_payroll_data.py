import pandas as pd
import numpy as np
from datetime import datetime

np.random.seed(42)

# Mid-size dataset: 500 employees
n_emp = 18000
employee_ids = np.arange(100001, 100001 + n_emp)

departments = ["Finance", "HR", "Operations", "Sales", "IT", "Manufacturing"]
locations = ["Hyderabad", "Bengaluru", "Mumbai", "Delhi", "Chennai", "Pune"]
grades = ["G1", "G2", "G3", "G4", "G5"]

# Generate basic attributes
df = pd.DataFrame({
    "employee_id": employee_ids,
    "name": [f"Employee_{i}" for i in employee_ids],
    "department": np.random.choice(departments, size=n_emp),
    "location": np.random.choice(locations, size=n_emp),
    "grade": np.random.choice(grades, size=n_emp),
})

# Date of joining between 2019-01-01 and 2024-12-31
doj_start = datetime(2019, 1, 1)
doj_end = datetime(2024, 12, 31)
doj_days = (doj_end - doj_start).days

df["doj"] = [
    (doj_start + pd.Timedelta(days=int(np.random.randint(0, doj_days)))).date()
    for _ in range(n_emp)
]

# Employment status: mostly Active, some Resigned
df["status"] = np.random.choice(
    ["Active", "Resigned"],
    size=n_emp,
    p=[0.9, 0.1]
)

df.to_csv("data_raw/employee_master.csv", index=False)
print("Created data_raw/employee_master.csv with", len(df), "rows")

# ---- Tax slabs table ----
tax_slabs = pd.DataFrame([
    {"slab_id": 1, "lower_limit": 0,       "upper_limit": 250000,     "tax_rate": 0.00},
    {"slab_id": 2, "lower_limit": 250000,  "upper_limit": 500000,     "tax_rate": 0.05},
    {"slab_id": 3, "lower_limit": 500000,  "upper_limit": 1000000,    "tax_rate": 0.20},
    {"slab_id": 4, "lower_limit": 1000000, "upper_limit": 999999999,  "tax_rate": 0.30},
])

tax_slabs.to_csv("data_raw/tax_slabs.csv", index=False)
print("Created data_raw/tax_slabs.csv with", len(tax_slabs), "rows")

# ---- Attendance table (1 month test) ----
from datetime import date, timedelta

def generate_attendance_for_month(emp_ids, year, month):
    # Build start and end dates for the given month
    start_date = date(year, month, 1)
    if month == 12:
        end_date = date(year + 1, 1, 1) - timedelta(days=1)
    else:
        end_date = date(year, month + 1, 1) - timedelta(days=1)

    all_rows = []

    for emp_id in emp_ids:
        current = start_date
        while current <= end_date:
            weekday = current.weekday()  # 0=Mon, 6=Sun
            if weekday < 5:
                shift_hours = 8
                unpaid_leave_hours = 0
                paid_leave_hours = 0
            else:
                shift_hours = 0
                unpaid_leave_hours = 0
                paid_leave_hours = 0

            all_rows.append({
                "employee_id": emp_id,
                "date": current,
                "shift_hours": shift_hours,
                "unpaid_leave_hours": unpaid_leave_hours,
                "paid_leave_hours": paid_leave_hours,
            })

            current += timedelta(days=1)

    return pd.DataFrame(all_rows)


# ---- Attendance table (3-month sample) ----
# Use only first 200 employees for now
# Use all employees now
att_emp_ids = employee_ids

all_attendance_dfs = []

# Generate 24 months: 2024-01 to 2025-12
years_months = [(2024, m) for m in range(1, 13)] + [(2025, m) for m in range(1, 13)]

for y, m in years_months:
    month_df = generate_attendance_for_month(att_emp_ids, y, m)
    all_attendance_dfs.append(month_df)

attendance_df = pd.concat(all_attendance_dfs, ignore_index=True)
attendance_df.to_csv("data_raw/attendance.csv", index=False)
print("Created data_raw/attendance.csv with", len(attendance_df), "rows")




