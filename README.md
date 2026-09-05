# PharmaCare — Patient Treatment Access & Journey Analytics

## Overview

PharmaCare is a healthcare analytics project designed to analyze patient treatment access, treatment initiation, access delays, discontinuation, and provider-level performance.

The project simulates a real-world healthcare analytics workflow from synthetic patient and access-event data through data validation, feature engineering, SQL analysis, statistical analysis, and Power BI reporting.

## Business Problem

Healthcare organizations need to understand where patients experience friction between diagnosis and treatment.

This project focuses on answering:

- How many diagnosed patients successfully initiate treatment?
- How long does it take patients to start treatment?
- Where do access delays occur?
- Does treatment initiation vary by insurance type?
- Does treatment access vary by therapy area or region?
- Are there differences in provider-level treatment performance?

## Dataset

The project uses synthetic healthcare data representing:

- 10,000 patients
- 60 healthcare providers
- 5 therapy areas
- 10,000 patient journey records
- 40,124 access events

The data is synthetic and created for analytical demonstration purposes.

## Key Findings

- 10,000 patients were diagnosed.
- 8,647 patients initiated treatment.
- Treatment initiation rate was 86.47%.
- 1,353 patients had not started treatment.
- 1,142 patients discontinued treatment.
- Discontinuation rate was 11.42%.
- Average diagnosis-to-treatment time was 28.87 days.
- Average access approval time was 17.09 days.
- Treatment initiation varied across insurance groups.
- Government Insurance and Self Pay showed lower treatment initiation rates than Private and Employer Insurance.

## Statistical Analysis

A chi-square test was used to evaluate the relationship between insurance type and treatment initiation.

- Chi-square statistic: 187.5135
- Degrees of freedom: 3
- p-value: < 0.001

The result indicates a statistically significant association between insurance type and treatment initiation within this synthetic dataset.

## Analytics Workflow

```text
Synthetic Data Generation
        ↓
Data Validation
        ↓
Data Cleaning & Feature Engineering
        ↓
SQL Analysis
        ↓
Statistical Analysis
        ↓
Power BI Dashboard
        ↓
Business Insights

Technology Stack
Python
Pandas
NumPy
SciPy
SQL
MySQL
Power BI
DAX
Git & GitHub
Project Structure

pharmacare-treatment-access-analytics/
│
├── data/
│   ├── raw/
│   └── processed/
│
├── documentation/
│   ├── BUSINESS_INSIGHTS.md
│   ├── DATA_DICTIONARY.md
│   ├── METHODOLOGY.md
│   └── PROJECT_REQUIREMENTS.md
│
├── powerbi/
│   └── Power BI dashboard
│
├── presentation/
│   └── project_summary.md
│
├── python/
│   ├── generate_data.py
│   ├── data_cleaning.py
│   ├── eda.py
│   └── statistical_analysis.py
│
├── sql/
│   ├── schema.sql
│   ├── data_quality.sql
│   ├── patient_journey.sql
│   ├── access_analysis.sql
│   ├── provider_analysis.sql
│   ├── executive_summary.sql
│   └── final_reporting_dataset.sql
│
├── README.md
└── requirements.txt

Power BI Dashboard

The Power BI solution is designed around four analytical pages:

Executive Overview
Patient Access & Treatment Journey
Payer & Therapy Analysis
Provider Performance

The dashboard focuses on:

Treatment initiation
Treatment timelines
Access approval delays
Treatment discontinuation
Payer variation
Therapy variation
Regional performance
Provider-level analysis

The final .pbix file will be added after dashboard design is finalized.

Business Recommendations
Investigate treatment initiation barriers among Government Insurance and Self Pay segments.
Investigate longer treatment timelines across therapy areas.
Review regional and payer-level access approval processes.
Monitor treatment discontinuation patterns by therapy and payer.
Use provider-level analysis to identify performance variation and improvement opportunities.
Disclaimer

This project uses synthetic healthcare data and does not contain real patient information or real clinical records.

The findings are intended for analytics demonstration purposes and should not be interpreted as real-world clinical or patient outcomes.