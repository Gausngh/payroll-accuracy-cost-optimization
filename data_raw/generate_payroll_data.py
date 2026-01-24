import pandas as pd
import numpy as np

# Temporary mid-size dataset: 500 employees
np.random.seed(42)

employee_ids = np.arange(100001, 100501)

departments = ["Finance", "HR", "Operations", "Sales", "IT"]
df = pd.DataFrame({
    "employee_id": employee_ids,
    "name": [f"Employee_{i}" for i in employee_ids],
    "department": np.random.choice(departments, size=len(employee_ids))
})

df.to_csv("data_raw/employee_master.csv", index=False)
print("Created data_raw/employee_master.csv with", len(df), "rows")