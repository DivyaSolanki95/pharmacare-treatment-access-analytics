# PharmaCare — Project Summary

## Objective

Analyze patient treatment access and identify potential barriers between diagnosis and treatment initiation.

## Dataset

- 10,000 patients
- 60 providers
- 5 therapies
- 10,000 patient journey records
- 40,124 access events

## Key Metrics

- Treatment initiation rate: 86.47%
- Treatment initiated: 8,647 patients
- Treatment not started: 1,353 patients
- Average time to treatment: 28.87 days
- Average access approval time: 17.09 days
- Discontinued patients: 1,142
- Discontinuation rate: 11.42%

## Key Findings

- Treatment initiation varies significantly across insurance groups.
- Government Insurance and Self Pay show lower treatment initiation rates.
- Treatment timelines vary across therapy areas.
- Access approval time varies across insurance groups and regions.
- Provider-level analysis highlights variation in treatment initiation and treatment timelines.

## Statistical Analysis

A chi-square test of independence was used to evaluate the relationship between insurance type and treatment initiation.

- Chi-square statistic: 187.5135
- Degrees of freedom: 3
- p-value: < 0.001

The result indicates a statistically significant association between insurance type and treatment initiation within the synthetic dataset.

## Technology

Python | Pandas | NumPy | SciPy | SQL | MySQL | Power BI | DAX | Git

## Analytical Workflow

Data Generation → Validation → Cleaning → Feature Engineering → SQL Analysis → Statistical Analysis → Power BI Dashboard → Business Insights

## Dashboard Pages

1. Executive Overview
2. Patient Access & Treatment Journey
3. Payer & Therapy Analysis
4. Provider Performance

## Business Recommendations

- Investigate treatment initiation barriers among Government Insurance and Self Pay segments.
- Investigate longer treatment timelines across therapy areas.
- Review regional and payer-level access approval processes.
- Monitor treatment discontinuation patterns by therapy and payer.
- Use provider-level analysis to identify performance variation and improvement opportunities.

## Disclaimer

All healthcare data used in this project is synthetic and intended only for analytics demonstration purposes.

The findings should not be interpreted as real-world clinical or patient outcomes.