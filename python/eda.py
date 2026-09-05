"""
PharmaCare - Exploratory Data Analysis

Purpose:
Perform basic exploratory analysis on the processed patient
treatment analytics dataset.
"""

import pandas as pd
from pathlib import Path


BASE_DIR = Path(__file__).resolve().parent.parent
DATA_PATH = BASE_DIR / "data" / "processed" / "final_patient_analytics.csv"


def main():
    print("=" * 70)
    print("PHARMACARE - EXPLORATORY DATA ANALYSIS")
    print("=" * 70)

    df = pd.read_csv(DATA_PATH)

    print("\nDATASET OVERVIEW")
    print("-" * 70)
    print(f"Rows    : {len(df):,}")
    print(f"Columns : {len(df.columns)}")

    print("\nTREATMENT STATUS")
    print("-" * 70)
    print(df["treatment_status"].value_counts())

    print("\nINSURANCE DISTRIBUTION")
    print("-" * 70)
    print(df["insurance_type"].value_counts())

    print("\nTHERAPY AREA DISTRIBUTION")
    print("-" * 70)
    print(df["therapy_area"].value_counts())

    print("\nREGION DISTRIBUTION")
    print("-" * 70)
    print(df["region"].value_counts())

    print("\nTREATMENT INITIATION RATE")
    print("-" * 70)
    initiation_rate = df["treatment_initiated_flag"].mean() * 100
    print(f"{initiation_rate:.2f}%")

    print("\nAVERAGE DAYS TO TREATMENT")
    print("-" * 70)
    avg_days = pd.to_numeric(
        df["days_to_treatment"],
        errors="coerce"
    ).mean()
    print(f"{avg_days:.2f} days")

    print("\nDISCONTINUATION RATE")
    print("-" * 70)
    discontinuation_rate = df["discontinued_flag"].mean() * 100
    print(f"{discontinuation_rate:.2f}%")

    print("\nEDA COMPLETED")
    print("=" * 70)


if __name__ == "__main__":
    main()