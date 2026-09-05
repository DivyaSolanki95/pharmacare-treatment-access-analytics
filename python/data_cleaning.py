import os
import pandas as pd
import numpy as np

# ============================================================
# PHARMACARE - DATA CLEANING & FEATURE ENGINEERING
# ============================================================

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

RAW_DIR = os.path.join(BASE_DIR, "data", "raw")
PROCESSED_DIR = os.path.join(BASE_DIR, "data", "processed")

os.makedirs(PROCESSED_DIR, exist_ok=True)


# ------------------------------------------------------------
# LOAD RAW DATA
# ------------------------------------------------------------

patients = pd.read_csv(
    os.path.join(RAW_DIR, "patients.csv")
)

providers = pd.read_csv(
    os.path.join(RAW_DIR, "providers.csv")
)

therapies = pd.read_csv(
    os.path.join(RAW_DIR, "therapies.csv")
)

journey = pd.read_csv(
    os.path.join(RAW_DIR, "patient_journey.csv")
)

access_events = pd.read_csv(
    os.path.join(RAW_DIR, "access_events.csv")
)


# ------------------------------------------------------------
# CONVERT DATE COLUMNS
# ------------------------------------------------------------

patients["diagnosis_date"] = pd.to_datetime(
    patients["diagnosis_date"]
)

journey_date_columns = [
    "diagnosis_date",
    "treatment_decision_date",
    "access_approval_date",
    "treatment_start_date",
    "discontinuation_date"
]

for column in journey_date_columns:

    journey[column] = pd.to_datetime(
        journey[column],
        errors="coerce"
    )

access_events["event_date"] = pd.to_datetime(
    access_events["event_date"]
)


# ------------------------------------------------------------
# MERGE PATIENT INFORMATION
# ------------------------------------------------------------

analytical = patients.merge(
    journey,
    on=["patient_id", "diagnosis_date"],
    how="left"
)

analytical = analytical.merge(
    therapies[
        [
            "therapy_id",
            "therapy_name",
            "therapy_area",
            "treatment_type",
            "manufacturer"
        ]
    ],
    on="therapy_id",
    how="left"
)

analytical = analytical.merge(
    providers[
        [
            "provider_id",
            "provider_name",
            "specialty",
            "provider_type"
        ]
    ],
    on="provider_id",
    how="left"
)


# ------------------------------------------------------------
# TIME-TO-TREATMENT METRICS
# ------------------------------------------------------------

analytical["days_diagnosis_to_decision"] = (
    analytical["treatment_decision_date"]
    - analytical["diagnosis_date"]
).dt.days


analytical["days_decision_to_approval"] = (
    analytical["access_approval_date"]
    - analytical["treatment_decision_date"]
).dt.days


analytical["days_approval_to_treatment"] = (
    analytical["treatment_start_date"]
    - analytical["access_approval_date"]
).dt.days


analytical["days_diagnosis_to_treatment"] = (
    analytical["treatment_start_date"]
    - analytical["diagnosis_date"]
).dt.days


# ------------------------------------------------------------
# ACCESS DELAY FLAG
# ------------------------------------------------------------

analytical["access_delay_flag"] = np.where(
    analytical["days_decision_to_approval"] > 20,
    "Delayed",
    "Within Target"
)


# ------------------------------------------------------------
# TREATMENT START FLAG
# ------------------------------------------------------------

analytical["treatment_started_flag"] = np.where(
    analytical["treatment_status"].isin(
        ["Started", "Discontinued"]
    ),
    1,
    0
)


# ------------------------------------------------------------
# DISCONTINUATION FLAG
# ------------------------------------------------------------

analytical["discontinued_flag"] = np.where(
    analytical["treatment_status"] == "Discontinued",
    1,
    0
)


# ------------------------------------------------------------
# ACCESS DELAY CATEGORY
# ------------------------------------------------------------

analytical["access_delay_category"] = pd.cut(
    analytical["days_decision_to_approval"],
    bins=[-1, 10, 20, 30, np.inf],
    labels=[
        "0-10 Days",
        "11-20 Days",
        "21-30 Days",
        "30+ Days"
    ]
)


# ------------------------------------------------------------
# DIAGNOSIS MONTH
# ------------------------------------------------------------

analytical["diagnosis_month"] = (
    analytical["diagnosis_date"]
    .dt.to_period("M")
    .astype(str)
)


# ------------------------------------------------------------
# CLEAN TEXT FIELDS
# ------------------------------------------------------------

text_columns = [
    "age_group",
    "gender",
    "region",
    "city",
    "insurance_type",
    "treatment_status",
    "therapy_name",
    "therapy_area",
    "treatment_type",
    "manufacturer",
    "provider_name",
    "specialty",
    "provider_type"
]

for column in text_columns:

    analytical[column] = (
        analytical[column]
        .astype("string")
        .str.strip()
    )


# ------------------------------------------------------------
# SELECT FINAL ANALYTICAL COLUMNS
# ------------------------------------------------------------

final_columns = [
    "patient_id",
    "age_group",
    "gender",
    "region",
    "city",
    "insurance_type",
    "provider_id",
    "provider_name",
    "provider_type",
    "specialty",
    "therapy_id",
    "therapy_name",
    "therapy_area",
    "treatment_type",
    "manufacturer",
    "diagnosis_date",
    "diagnosis_month",
    "treatment_decision_date",
    "access_approval_date",
    "treatment_start_date",
    "treatment_status",
    "discontinuation_date",
    "discontinuation_reason",
    "days_diagnosis_to_decision",
    "days_decision_to_approval",
    "days_approval_to_treatment",
    "days_diagnosis_to_treatment",
    "access_delay_flag",
    "access_delay_category",
    "treatment_started_flag",
    "discontinued_flag"
]

analytical = analytical[final_columns]


# ------------------------------------------------------------
# DATA QUALITY CHECKS
# ------------------------------------------------------------

print("=" * 70)
print("PHARMACARE - ANALYTICAL DATASET CREATION")
print("=" * 70)

print()
print("DATASET SIZE")
print("-" * 70)

print(f"Rows    : {len(analytical):,}")
print(f"Columns : {len(analytical.columns)}")


print()
print("DUPLICATE PATIENT RECORDS")
print("-" * 70)

print(
    analytical["patient_id"].duplicated().sum()
)


print()
print("TREATMENT STATUS")
print("-" * 70)

print(
    analytical["treatment_status"]
    .value_counts()
    .to_string()
)


print()
print("AVERAGE TIME TO TREATMENT")
print("-" * 70)

avg_time = analytical[
    "days_diagnosis_to_treatment"
].mean()

print(
    f"{avg_time:.2f} days"
)


print()
print("MEDIAN TIME TO TREATMENT")
print("-" * 70)

median_time = analytical[
    "days_diagnosis_to_treatment"
].median()

print(
    f"{median_time:.2f} days"
)


print()
print("ACCESS DELAY DISTRIBUTION")
print("-" * 70)

print(
    analytical["access_delay_category"]
    .value_counts()
    .sort_index()
    .to_string()
)


# ------------------------------------------------------------
# SAVE PROCESSED DATA
# ------------------------------------------------------------

output_path = os.path.join(
    PROCESSED_DIR,
    "patient_treatment_analytics.csv"
)

analytical.to_csv(
    output_path,
    index=False
)


print()
print("=" * 70)
print("PROCESSED DATASET CREATED")
print("=" * 70)

print()
print(f"Output:")
print(output_path)

print()
print("DATA CLEANING & FEATURE ENGINEERING COMPLETED.")
print("=" * 70)