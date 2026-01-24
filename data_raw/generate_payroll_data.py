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
