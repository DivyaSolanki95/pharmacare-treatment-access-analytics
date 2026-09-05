"""
PharmaCare - Statistical Analysis

Purpose:
Evaluate whether treatment initiation differs across
insurance groups using a chi-square test.
"""

import pandas as pd
from pathlib import Path
from scipy.stats import chi2_contingency


BASE_DIR = Path(__file__).resolve().parent.parent
DATA_PATH = BASE_DIR / "data" / "processed" / "final_patient_analytics.csv"


def main():
    print("=" * 70)
    print("PHARMACARE - STATISTICAL ANALYSIS")
    print("=" * 70)

    df = pd.read_csv(DATA_PATH)

    contingency_table = pd.crosstab(
        df["insurance_type"],
        df["treatment_initiated_flag"]
    )

    print("\nTREATMENT INITIATION BY INSURANCE")
    print("-" * 70)
    print(contingency_table)

    chi2, p_value, degrees_of_freedom, expected = chi2_contingency(
        contingency_table
    )

    print("\nCHI-SQUARE TEST")
    print("-" * 70)
    print(f"Chi-square statistic : {chi2:.4f}")
    print(f"P-value              : {p_value:.6f}")
    print(f"Degrees of freedom   : {degrees_of_freedom}")

    print("\nINTERPRETATION")
    print("-" * 70)

    if p_value < 0.05:
        print(
            "Treatment initiation is statistically associated "
            "with insurance type (p < 0.05)."
        )
    else:
        print(
            "No statistically significant association was found "
            "between insurance type and treatment initiation."
        )

    print("\nSTATISTICAL ANALYSIS COMPLETED")
    print("=" * 70)


if __name__ == "__main__":
    main()