import os
import numpy as np
import pandas as pd

# ============================================================
# PHARMACARE - SYNTHETIC HEALTHCARE DATA GENERATOR
# ============================================================
# Purpose:
# Generate realistic synthetic patient-treatment journey
# data for healthcare access and treatment analytics.
#
# IMPORTANT:
# This is completely synthetic data.
# No real patient information is used.
# ============================================================

np.random.seed(42)

# ------------------------------------------------------------
# PROJECT PATHS
# ------------------------------------------------------------

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

RAW_DIR = os.path.join(BASE_DIR, "data", "raw")

os.makedirs(RAW_DIR, exist_ok=True)


# ------------------------------------------------------------
# CONFIGURATION
# ------------------------------------------------------------

NUM_PATIENTS = 10000
NUM_PROVIDERS = 60


# ------------------------------------------------------------
# REFERENCE DATA
# ------------------------------------------------------------

REGIONS = [
    "North",
    "South",
    "East",
    "West",
    "Central"
]

CITIES = {
    "North": ["Delhi", "Chandigarh", "Jaipur", "Lucknow"],
    "South": ["Bengaluru", "Chennai", "Hyderabad", "Kochi"],
    "East": ["Kolkata", "Bhubaneswar", "Patna", "Guwahati"],
    "West": ["Mumbai", "Pune", "Ahmedabad", "Surat"],
    "Central": ["Bhopal", "Indore", "Nagpur", "Raipur"]
}

THERAPIES = [
    {
        "therapy_id": "TH001",
        "therapy_name": "OncoCare",
        "therapy_area": "Oncology",
        "treatment_type": "Specialty",
        "manufacturer": "NovaPharma"
    },
    {
        "therapy_id": "TH002",
        "therapy_name": "CardioPlus",
        "therapy_area": "Cardiology",
        "treatment_type": "Chronic",
        "manufacturer": "HealthCore"
    },
    {
        "therapy_id": "TH003",
        "therapy_name": "Immunexa",
        "therapy_area": "Immunology",
        "treatment_type": "Specialty",
        "manufacturer": "MedAxis"
    },
    {
        "therapy_id": "TH004",
        "therapy_name": "Neurovia",
        "therapy_area": "Neurology",
        "treatment_type": "Specialty",
        "manufacturer": "BioNova"
    },
    {
        "therapy_id": "TH005",
        "therapy_name": "GlucoBalance",
        "therapy_area": "Diabetes",
        "treatment_type": "Chronic",
        "manufacturer": "LifeWell"
    }
]

THERAPY_DF = pd.DataFrame(THERAPIES)

INSURANCE_TYPES = [
    "Private Insurance",
    "Government Insurance",
    "Employer Insurance",
    "Self Pay"
]

GENDER = [
    "Female",
    "Male",
    "Other"
]

AGE_GROUPS = [
    "18-34",
    "35-49",
    "50-64",
    "65+"
]

PROVIDER_TYPES = [
    "Hospital",
    "Specialty Clinic",
    "Private Practice"
]

SPECIALTIES = [
    "Oncology",
    "Cardiology",
    "Immunology",
    "Neurology",
    "Endocrinology"
]

ACCESS_EVENT_TYPES = [
    "Access Request",
    "Prior Authorization",
    "Insurance Review",
    "Documentation Review",
    "Financial Assistance",
    "Treatment Scheduling"
]

ACCESS_REASONS = [
    "Insurance Approval",
    "Prior Authorization",
    "Documentation Issue",
    "Cost / Affordability",
    "Provider Delay",
    "Treatment Availability",
    "Patient Decision"
]


# ============================================================
# 1. PROVIDERS
# ============================================================

provider_rows = []

for i in range(1, NUM_PROVIDERS + 1):

    region = np.random.choice(REGIONS)

    provider_rows.append({
        "provider_id": f"PR{i:03d}",
        "provider_name": f"Healthcare Provider {i:03d}",
        "region": region,
        "specialty": np.random.choice(SPECIALTIES),
        "provider_type": np.random.choice(PROVIDER_TYPES)
    })

providers_df = pd.DataFrame(provider_rows)


# ============================================================
# 2. PATIENTS
# ============================================================

patient_rows = []

start_date = pd.Timestamp("2023-01-01")
end_date = pd.Timestamp("2025-12-31")

for i in range(1, NUM_PATIENTS + 1):

    region = np.random.choice(REGIONS)

    city = np.random.choice(CITIES[region])

    therapy = np.random.choice(THERAPY_DF["therapy_id"])

    provider = np.random.choice(providers_df["provider_id"])

    diagnosis_date = start_date + pd.to_timedelta(
        np.random.randint(
            0,
            (end_date - start_date).days
        ),
        unit="D"
    )

    patient_rows.append({
        "patient_id": f"PT{i:05d}",
        "age_group": np.random.choice(
            AGE_GROUPS,
            p=[0.18, 0.30, 0.32, 0.20]
        ),
        "gender": np.random.choice(
            GENDER,
            p=[0.49, 0.49, 0.02]
        ),
        "region": region,
        "city": city,
        "insurance_type": np.random.choice(
            INSURANCE_TYPES,
            p=[0.38, 0.27, 0.20, 0.15]
        ),
        "provider_id": provider,
        "therapy_id": therapy,
        "diagnosis_date": diagnosis_date
    })

patients_df = pd.DataFrame(patient_rows)


# ============================================================
# 3. PATIENT JOURNEY
# ============================================================

journey_rows = []
access_event_rows = []

for _, patient in patients_df.iterrows():

    patient_id = patient["patient_id"]

    diagnosis_date = patient["diagnosis_date"]

    insurance = patient["insurance_type"]

    therapy_id = patient["therapy_id"]

    # Treatment recommendation happens shortly after diagnosis
    recommendation_days = np.random.randint(1, 8)

    treatment_decision_date = (
        diagnosis_date +
        pd.Timedelta(days=recommendation_days)
    )

    # Base access delay
    base_access_delay = np.random.randint(3, 16)

    # Insurance can increase access delay
    if insurance == "Government Insurance":
        base_access_delay += np.random.randint(5, 15)

    elif insurance == "Self Pay":
        base_access_delay += np.random.randint(3, 12)

    elif insurance == "Employer Insurance":
        base_access_delay += np.random.randint(2, 8)

    # Specialty therapies generally require more processing
    if therapy_id in ["TH001", "TH003", "TH004"]:
        base_access_delay += np.random.randint(3, 10)

    access_approval_date = (
        treatment_decision_date +
        pd.Timedelta(days=base_access_delay)
    )

    # Probability of treatment start
    start_probability = 0.90

    if insurance == "Government Insurance":
        start_probability -= 0.07

    if insurance == "Self Pay":
        start_probability -= 0.10

    if base_access_delay > 30:
        start_probability -= 0.10

    treatment_started = (
        np.random.random() < start_probability
    )

    if treatment_started:

        treatment_start_delay = np.random.randint(2, 15)

        treatment_start_date = (
            access_approval_date +
            pd.Timedelta(days=treatment_start_delay)
        )

        treatment_status = "Started"

        # Discontinuation probability
        discontinuation_probability = 0.12

        if base_access_delay > 30:
            discontinuation_probability += 0.08

        if insurance == "Self Pay":
            discontinuation_probability += 0.08

        discontinued = (
            np.random.random() < discontinuation_probability
        )

        if discontinued:

            discontinuation_date = (
                treatment_start_date +
                pd.Timedelta(days=np.random.randint(45, 240))
            )

            discontinuation_reason = np.random.choice(
                [
                    "Cost / Affordability",
                    "Adverse Event",
                    "Treatment Ineffectiveness",
                    "Patient Decision",
                    "Access Issue"
                ]
            )

            treatment_status = "Discontinued"

        else:

            discontinuation_date = pd.NaT
            discontinuation_reason = None

    else:

        treatment_start_date = pd.NaT

        treatment_status = "Not Started"

        discontinuation_date = pd.NaT

        discontinuation_reason = None


    # --------------------------------------------------------
    # Journey record
    # --------------------------------------------------------

    journey_rows.append({
        "patient_id": patient_id,
        "diagnosis_date": diagnosis_date,
        "treatment_decision_date": treatment_decision_date,
        "access_approval_date": access_approval_date,
        "treatment_start_date": treatment_start_date,
        "treatment_status": treatment_status,
        "discontinuation_date": discontinuation_date,
        "discontinuation_reason": discontinuation_reason
    })


    # ========================================================
    # ACCESS EVENTS
    # ========================================================

    event_count = np.random.randint(2, 7)

    current_date = treatment_decision_date

    for event_number in range(event_count):

        event_type = np.random.choice(
            ACCESS_EVENT_TYPES
        )

        event_delay = np.random.randint(1, 8)

        current_date = (
            current_date +
            pd.Timedelta(days=event_delay)
        )

        event_status = np.random.choice(
            ["Completed", "Delayed", "Pending"],
            p=[0.70, 0.20, 0.10]
        )

        if event_status == "Delayed":

            delay_days = np.random.randint(3, 21)

            reason = np.random.choice(
                ACCESS_REASONS
            )

        else:

            delay_days = 0

            reason = "No Delay"

        access_event_rows.append({
            "event_id": (
                f"EV{len(access_event_rows) + 1:06d}"
            ),
            "patient_id": patient_id,
            "event_date": current_date,
            "event_type": event_type,
            "event_status": event_status,
            "delay_days": delay_days,
            "reason": reason
        })


journey_df = pd.DataFrame(journey_rows)

access_events_df = pd.DataFrame(access_event_rows)


# ============================================================
# 4. SAVE DATASETS
# ============================================================

patients_df.to_csv(
    os.path.join(RAW_DIR, "patients.csv"),
    index=False
)

providers_df.to_csv(
    os.path.join(RAW_DIR, "providers.csv"),
    index=False
)

THERAPY_DF.to_csv(
    os.path.join(RAW_DIR, "therapies.csv"),
    index=False
)

journey_df.to_csv(
    os.path.join(RAW_DIR, "patient_journey.csv"),
    index=False
)

access_events_df.to_csv(
    os.path.join(RAW_DIR, "access_events.csv"),
    index=False
)


# ============================================================
# 5. DATA GENERATION SUMMARY
# ============================================================

print("=" * 70)
print("PHARMACARE - SYNTHETIC HEALTHCARE DATA GENERATION")
print("=" * 70)

print()
print("DATASETS GENERATED")
print("-" * 70)

print(f"Patients          : {len(patients_df):,} rows")
print(f"Providers         : {len(providers_df):,} rows")
print(f"Therapies         : {len(THERAPY_DF):,} rows")
print(f"Patient Journey   : {len(journey_df):,} rows")
print(f"Access Events     : {len(access_events_df):,} rows")

print()
print("PATIENT STATUS")
print("-" * 70)

print(
    journey_df["treatment_status"]
    .value_counts()
    .to_string()
)

print()
print("THERAPY DISTRIBUTION")
print("-" * 70)

print(
    patients_df["therapy_id"]
    .value_counts()
    .sort_index()
    .to_string()
)

print()
print("INSURANCE DISTRIBUTION")
print("-" * 70)

print(
    patients_df["insurance_type"]
    .value_counts()
    .to_string()
)

print()
print("OUTPUT DIRECTORY")
print("-" * 70)

print(RAW_DIR)

print()
print("DATA GENERATION COMPLETED SUCCESSFULLY.")
print("=" * 70)