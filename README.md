# PharmaCare — Patient Treatment Access & Journey Analytics

## Overview

PharmaCare is a healthcare analytics project designed to analyze patient treatment access, treatment initiation, access delays, treatment discontinuation, and provider-level performance.

The project simulates a real-world healthcare analytics workflow using synthetic healthcare data, covering data generation, validation, cleaning, feature engineering, SQL analysis, statistical analysis, and Power BI reporting.

> **Disclaimer:** All patient, provider, therapy, and access data used in this project is synthetic and created for analytics demonstration purposes. It does not represent real patients, clinical records, or real-world healthcare outcomes.

---

## Business Problem

Healthcare organizations need to understand where patients experience friction between diagnosis and treatment initiation.

PharmaCare focuses on answering the following business questions:

- How many diagnosed patients successfully initiate treatment?
- How long does it take patients to start treatment?
- Where do access delays occur?
- Does treatment initiation vary by insurance type?
- Does treatment access vary by therapy area or region?
- Are there differences in provider-level treatment performance?
- Which patient segments may require further investigation?

---

## Dataset

The project uses a synthetic healthcare dataset representing:

| Dataset | Records |
|---|---:|
| Patients | 10,000 |
| Providers | 60 |
| Therapies | 5 |
| Patient Journey Records | 10,000 |
| Access Events | 40,124 |

The dataset contains patient demographics, insurance information, geographic information, provider information, therapy information, treatment journey dates, treatment status, discontinuation information, and access-event details.

---

## Key Metrics

| Metric | Result |
|---|---:|
| Diagnosed Patients | 10,000 |
| Treatment Initiated | 8,647 |
| Treatment Not Started | 1,353 |
| Treatment Initiation Rate | 86.47% |
| Discontinued Patients | 1,142 |
| Discontinuation Rate Among Initiators | 13.21% |
| Average Days to Treatment | 28.87 days |
| Average Access Approval Time | 17.09 days |
| Access Events | 40,124 |

### Treatment Status Distribution

| Treatment Status | Patients | Percentage |
|---|---:|---:|
| Started | 7,505 | 75.05% |
| Not Started | 1,353 | 13.53% |
| Discontinued | 1,142 | 11.42% |

Patients classified as **Started** or **Discontinued** are considered treatment initiators because both groups successfully reached treatment initiation.

---

## Key Findings

### 1. Treatment Initiation

8,647 out of 10,000 diagnosed patients initiated treatment, resulting in an overall treatment initiation rate of **86.47%**.

However, **1,353 patients had not started treatment**, representing an important segment for access-barrier investigation.

### 2. Treatment Discontinuation

1,142 patients were classified as discontinued.

The discontinuation rate among treatment initiators was **13.21%**.

This allows the project to distinguish between patients who never initiated treatment and patients who initiated treatment but later discontinued.

### 3. Treatment Timeline

The average time between diagnosis and treatment initiation was **28.87 days**.

This metric is used to evaluate the overall patient journey and identify potential differences in treatment timelines across therapy areas, insurance groups, regions, and providers.

### 4. Access Approval

The average access approval time was **17.09 days**.

Access-event analysis is used to investigate delays by event type, reason, region, and insurance type.

### 5. Insurance Variation

Treatment initiation varies across insurance groups.

**Government Insurance** and **Self Pay** segments showed lower treatment initiation compared with **Private** and **Employer Insurance** groups in the synthetic dataset.

These differences are treated as areas for further investigation rather than causal conclusions.

### 6. Therapy and Regional Variation

Treatment initiation and treatment timelines vary across therapy areas and geographic regions.

The analysis enables identification of areas with comparatively longer treatment timelines or lower initiation rates.

### 7. Provider Variation

Provider-level analysis highlights differences in:

- Patient volume
- Treatment initiation rate
- Average days to treatment
- Treatment discontinuation rate

Provider-level differences are intended to identify areas for operational investigation rather than to establish provider causality or clinical quality.

---

## Statistical Analysis

A **Chi-Square Test of Independence** was performed to evaluate the relationship between insurance type and treatment initiation.

### Results

| Statistic | Result |
|---|---:|
| Chi-Square Statistic | 187.5135 |
| Degrees of Freedom | 3 |
| p-value | < 0.001 |

The result indicates a **statistically significant association** between insurance type and treatment initiation within this synthetic dataset.

> Statistical significance indicates an association in the generated dataset. It does not establish that insurance type causes treatment initiation differences.

---

## Analytical Workflow

```text
Synthetic Data Generation
          ↓
Data Validation
          ↓
Data Cleaning
          ↓
Feature Engineering
          ↓
SQL Analysis
          ↓
Statistical Analysis
          ↓
Power BI Dashboard
          ↓
Business Insights

Data Validation

Before analytical reporting, SQL-based data-quality checks were performed to validate:

Duplicate patient records
Provider referential integrity
Therapy referential integrity
Patient journey references
Access event references
Treatment journey date consistency
Access approval date consistency
Treatment status completeness
Treatment date consistency
Overall dataset record counts

The final database contains:

10,000 patients
60 providers
5 therapies
10,000 patient journey records
40,124 access events
SQL Analysis

The SQL layer contains separate analytical modules for different business questions.

Patient Journey Analysis

sql/patient_journey.sql

Analyzes:

Patient journey funnel
Treatment initiation rate
Treatment discontinuation rate
Diagnosis-to-treatment time
Therapy-level treatment performance
Regional treatment performance
Insurance-level access delays
Long access delays
Access Analysis

sql/access_analysis.sql

Analyzes:

Total access events
Access events by event type
Access events by status
Top access barriers
Regional access barriers
Insurance-level access barriers
High-delay access events
Top individual patient access delays
Provider Analysis

sql/provider_analysis.sql

Analyzes:

Provider patient volume
Provider treatment initiation rate
Provider treatment-access time
Provider discontinuation rate
Overall provider performance
Executive Summary

sql/executive_summary.sql

Creates executive-level metrics covering:

Diagnosed patients
Treatment initiation
Treatment not started
Treatment initiation rate
Discontinuation
Average treatment timeline
Long access delays
Therapy performance
Insurance performance
Final Reporting Dataset

sql/final_reporting_dataset.sql

Creates the patient-level final_patient_analytics reporting table used as the analytical foundation for reporting.

The dataset combines:

Patient information
Provider information
Therapy information
Treatment journey information
Journey timing metrics
Access-delay categories
Treatment initiation flags
Treatment discontinuation flags
Long access-delay flags
Power BI Dashboard

The Power BI dashboard provides an interactive reporting layer for the project.

Dashboard Pages
1. Executive Overview

Provides a high-level view of:

Diagnosed patients
Treatment initiation
Treatment initiation rate
Treatment discontinuation
Average days to treatment
Overall treatment journey performance
2. Patient Access & Treatment Journey

Focuses on:

Treatment journey progression
Treatment status
Diagnosis-to-treatment timelines
Access approval delays
Regional variation
Patient access patterns
3. Payer & Therapy Analysis

Analyzes:

Insurance-level treatment initiation
Insurance-level access delays
Therapy-area treatment performance
Treatment timelines
Payer and therapy variation
4. Provider Performance

Analyzes:

Provider patient volume
Treatment initiation rate
Average days to treatment
Discontinuation rate
Provider-level performance variation
Dashboard Filters

The dashboard supports interactive analysis through filters/slicers for relevant dimensions such as:

Region
Insurance Type
Therapy Area
Provider
Treatment Status

The dashboard is designed to allow recruiters and reviewers to move from executive-level KPIs into specific access, payer, therapy, regional, and provider-level patterns.

Business Recommendations

Based on the analysis of the synthetic dataset:

1. Investigate Lower-Initiation Insurance Segments

Further investigate treatment initiation barriers among Government Insurance and Self Pay patients.

Potential areas for operational investigation include access approval processes, documentation requirements, and payment-related friction.

2. Investigate Treatment Timeline Variation

Review therapy areas with comparatively longer diagnosis-to-treatment timelines to identify potential access bottlenecks.

3. Review Regional and Payer-Level Delays

Compare access approval performance across regions and insurance groups to identify areas with higher delay rates.

4. Monitor Treatment Discontinuation

Track discontinuation patterns across therapy areas, insurance groups, and providers to identify segments requiring deeper analysis.

5. Investigate Provider-Level Variation

Use provider-level metrics to identify differences in treatment initiation and treatment timelines and determine whether operational factors warrant further investigation.

Technology Stack
Python
Pandas
NumPy
SciPy
SQL
MySQL
Power BI
DAX
Git
GitHub
Project Structure
pharmacare-treatment-access-analytics/
│
├── data/
│   ├── raw/
│   │   ├── access_events.csv
│   │   ├── patient_journey.csv
│   │   ├── patients.csv
│   │   ├── providers.csv
│   │   └── therapies.csv
│   │
│   └── processed/
│       └── final_patient_analytics.csv
│
├── documentation/
│   ├── BUSINESS_INSIGHTS.md
│   ├── DATA_DICTIONARY.md
│   ├── METHODOLOGY.md
│   └── PROJECT_REQUIREMENTS.md
│
├── powerbi/
│   └── Power BI dashboard files
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
Project Highlights
Built an end-to-end healthcare analytics workflow using synthetic data.
Generated and analyzed 10,000 patient records and 40,124 access events.
Designed a relational MySQL database with patient, provider, therapy, journey, and access-event tables.
Implemented SQL data-quality and referential-integrity checks.
Created patient journey and treatment-access metrics using SQL.
Performed statistical analysis using SciPy.
Built an interactive Power BI dashboard for executive and operational analysis.
Created a patient-level reporting dataset for BI consumption.
Translated analytical findings into business-oriented recommendations.
Important Note

This project is intended to demonstrate analytics, SQL, statistical analysis, data modeling, and business intelligence skills.

The dataset is 100% synthetic and does not contain real patient information, protected health information (PHI), clinical records, or real-world patient outcomes.

Therefore, all findings and recommendations should be interpreted strictly as demonstrations of the analytical workflow.