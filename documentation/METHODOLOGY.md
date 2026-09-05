# PharmaCare — Methodology

## 1. Project Objective

The objective of the PharmaCare analytics project is to analyze the patient treatment journey from diagnosis through treatment initiation and discontinuation.

The project focuses on identifying potential barriers in treatment access, measuring treatment timelines, comparing performance across insurance and therapy segments, and evaluating provider-level variation.

The complete workflow follows:

```text
Data Generation
      ↓
Data Validation
      ↓
Data Cleaning
      ↓
Data Integration
      ↓
Feature Engineering
      ↓
Exploratory Data Analysis
      ↓
SQL Analysis
      ↓
Statistical Analysis
      ↓
Power BI Reporting
      ↓
Business Insights

2. Data Generation

Synthetic healthcare data was generated using Python to create a realistic analytical environment without using real patient information.

The project contains the following core datasets:
| Dataset             | Approximate Records | Purpose                                       |
| ------------------- | ------------------: | --------------------------------------------- |
| patients.csv        |              10,000 | Patient demographic and insurance information |
| providers.csv       |                  60 | Healthcare provider information               |
| therapies.csv       |                   5 | Therapy and therapeutic-area information      |
| patient_journey.csv |              10,000 | Patient treatment journey information         |
| access_events.csv   |              40,124 | Patient access and approval events            |


The synthetic dataset was designed to support analysis across:

Insurance type
Therapy area
Region
Provider
Treatment status
Treatment timelines
Access events
3. Data Validation

Before analytical processing, the datasets were checked for structural and logical consistency.

The validation process considered:

File availability
Column structure
Data types
Missing values
Duplicate records
Identifier consistency
Date consistency
Patient-level consistency
Treatment-status consistency

The validation stage helps ensure that downstream calculations are based on consistent records.

4. Data Cleaning

Python and Pandas were used to process the raw datasets.

The cleaning workflow included:

Loading the raw CSV files.
Inspecting dataset dimensions and column structures.
Standardizing date fields.
Checking missing values.
Checking duplicate records.
Validating patient identifiers.
Validating treatment-related fields.
Handling applicable missing journey dates.
Combining related datasets using common identifiers.
Producing the final analytical dataset.

The final processed dataset is:

data/processed/final_patient_analytics.csv

This dataset contains the integrated patient-level analytical information used for downstream analysis and reporting.

5. Data Integration

The project integrates information from multiple healthcare-related datasets.

The main relationships are based on identifiers such as:

patient_id
provider_id
therapy_id

The patient dataset provides the base patient population.

Provider information is connected through provider_id.

Therapy information is connected through therapy_id.

Patient treatment journey and access-event information are connected through patient_id.

This integration creates a unified analytical view of the patient treatment-access journey.

6. Feature Engineering

Additional analytical fields were created to support business analysis.

Important derived fields include:

Treatment Initiation Flag

Identifies whether a patient initiated treatment.

1 = Treatment initiated
0 = Treatment not initiated
Discontinued Flag

Identifies whether a patient discontinued treatment.

1 = Discontinued
0 = Not discontinued
Days to Treatment

Measures the number of days between diagnosis and treatment initiation.

Treatment Start Date - Diagnosis Date

This metric is used to evaluate treatment access timelines.

Access Approval Days

Measures the time associated with the access approval process.

This metric helps identify potential access and administrative delays.

Access Delay Category

Patients can be grouped into delay categories to make access bottlenecks easier to analyze.

Treatment Status

The project uses treatment-status categories including:

Started
Not Started
Discontinued

These fields allow patient outcomes to be compared across different business dimensions.

7. Exploratory Data Analysis

Exploratory Data Analysis was performed using Python and Pandas.

The EDA process evaluates:

Dataset size
Treatment-status distribution
Insurance distribution
Therapy-area distribution
Regional distribution
Treatment initiation
Average treatment timeline
Treatment discontinuation

The EDA script is:

python/eda.py

Key observed metrics include:

10,000 patient records
86.47% treatment initiation rate
28.87 days average time to treatment
11.42% discontinuation rate

8. SQL Analysis

MySQL was used to perform structured analytical queries.

The SQL analysis covers:

Executive Analysis

High-level treatment access and patient metrics.

Patient Journey Analysis

Analysis of progression from diagnosis through treatment.

Access Analysis

Analysis of access events, approval timelines, and delays.

Provider Analysis

Comparison of provider-level treatment performance.

Data Quality

Validation and quality checks on the analytical data.

The SQL layer is organized into:

sql/
├── schema.sql
├── data_quality.sql
├── patient_journey.sql
├── access_analysis.sql
├── provider_analysis.sql
├── executive_summary.sql
└── final_reporting_dataset.sql

9. Statistical Analysis

Statistical analysis was performed using Python and SciPy.

A chi-square test of independence was used to evaluate whether treatment initiation was associated with insurance type.

Hypotheses

Null hypothesis (H₀):

Treatment initiation and insurance type are independent.

Alternative hypothesis (H₁):

Treatment initiation and insurance type are associated.

Result
Chi-square statistic: 187.5135
Degrees of freedom: 3
p-value: < 0.001

The p-value is below the 0.05 significance threshold.

Therefore, the analysis indicates a statistically significant association between insurance type and treatment initiation within the synthetic dataset.

The statistical analysis script is:

python/statistical_analysis.py
10. Power BI Reporting

Power BI is used as the final reporting and visualization layer.

The dashboard is structured into four pages:

Page 1 — Executive Overview

Provides a high-level view of:

Patient population
Treatment initiation
Treatment discontinuation
Treatment timelines
Access approval performance
Page 2 — Patient Access & Treatment Journey

Focuses on:

Patient journey stages
Treatment progression
Time to treatment
Access approval delays
Page 3 — Payer & Therapy Analysis

Focuses on:

Insurance-level treatment initiation
Therapy-area performance
Payer differences
Treatment-access variation
Page 4 — Provider Performance

Focuses on:

Provider-level patient volume
Treatment initiation
Treatment timelines
Provider performance variation

DAX measures are used to calculate and display key analytical metrics.

11. Business Analysis

The analytical results are interpreted from an operational and access perspective rather than a clinical perspective.

The analysis focuses on identifying:

Treatment-access gaps
Delays in the patient journey
Insurance-level differences
Therapy-level variation
Regional variation
Provider-level variation
Potential areas for operational improvement
12. Key Metrics

The primary metrics used throughout the project include:

Metric	Description
Treatment Initiation Rate	Percentage of patients who initiated treatment
Discontinuation Rate	Percentage of patients who discontinued treatment
Average Days to Treatment	Average time between diagnosis and treatment initiation
Average Access Approval Days	Average time associated with access approval
Patient Volume	Number of patients in a selected segment
Access Events	Number of recorded access-related events
13. Quality and Reproducibility

The project separates:

Raw data
Processed data
Python processing
SQL analysis
Documentation
Visualization

This structure allows individual stages of the analytical workflow to be inspected and reproduced independently.

Python scripts are maintained in the python/ directory and SQL analysis is maintained in the sql/ directory.

14. Limitations

The project has several limitations:

The healthcare data is synthetic.
The dataset does not represent real clinical outcomes.
Treatment-access relationships are simulated for analytical demonstration.
Statistical findings describe the generated dataset and should not be generalized to real patient populations.
The analysis identifies potential operational patterns but does not establish clinical causation.

15. Final Analytical Workflow

The completed methodology can be summarized as:

Synthetic Healthcare Data
          ↓
Data Validation
          ↓
Data Cleaning
          ↓
Data Integration
          ↓
Feature Engineering
          ↓
EDA with Python
          ↓
SQL Analysis with MySQL
          ↓
Statistical Analysis with SciPy
          ↓
Power BI + DAX
          ↓
Business Insights

The final objective is to transform raw healthcare-related data into an understandable analytical solution that can support investigation of patient treatment-access performance.


---

# `documentation/DATA_DICTIONARY.md`

Replace the entire file with this:

```markdown
# PharmaCare — Data Dictionary

## Overview

The PharmaCare project uses multiple synthetic healthcare datasets representing patients, providers, therapies, treatment journeys, and access events.

The datasets are connected through common identifiers and are integrated into the processed analytical dataset:

```text
data/processed/final_patient_analytics.csv

All data used in this project is synthetic.

1. patients.csv

Contains the core patient population and demographic/insurance attributes.

Column	Description	Data Type
patient_id	Unique identifier assigned to each patient	Integer / ID
age_group	Patient age category	Categorical
gender	Patient gender category	Categorical
region	Geographic region associated with the patient	Categorical
city	Patient city	Categorical
insurance_type	Patient insurance/payer category	Categorical
provider_id	Identifier of the patient's healthcare provider	Integer / ID
therapy_id	Identifier of the assigned therapy	Integer / ID
diagnosis_date	Date on which the patient was diagnosed	Date
Primary Key
patient_id
Important Dimensions
Age group
Gender
Region
City
Insurance type
Provider
Therapy
2. providers.csv

Contains information about healthcare providers associated with patients.

Column	Description	Data Type
provider_id	Unique provider identifier	Integer / ID
provider_name	Name assigned to the provider in the synthetic dataset	Text
region	Geographic region of the provider	Categorical
specialty	Medical specialty associated with the provider	Categorical
provider_type	Provider classification/type	Categorical
Primary Key
provider_id
Purpose

Provider data is used to evaluate differences in treatment initiation, patient volume, and treatment timelines across providers.

3. therapies.csv

Contains information about the therapies represented in the dataset.

Column	Description	Data Type
therapy_id	Unique therapy identifier	Integer / ID
therapy_name	Name assigned to the therapy	Text
therapy_area	Therapeutic area associated with the therapy	Categorical
treatment_type	Type/category of treatment	Categorical
manufacturer	Manufacturer associated with the therapy	Text
Primary Key
therapy_id
Therapeutic Areas

The dataset contains five therapy areas:

Neurology
Oncology
Cardiology
Immunology
Diabetes
4. patient_journey.csv

Contains information describing the treatment journey of each patient.

Column	Description	Data Type
patient_id	Identifier of the patient	Integer / ID
diagnosis_date	Date of diagnosis	Date
treatment_decision_date	Date when treatment was decided	Date
access_approval_date	Date when access was approved	Date
treatment_start_date	Date treatment began	Date
treatment_status	Current treatment status	Categorical
discontinuation_date	Date treatment was discontinued, where applicable	Date
discontinuation_reason	Reason associated with treatment discontinuation	Categorical / Text
Patient Journey

The conceptual journey is:

Diagnosis
   ↓
Treatment Decision
   ↓
Access Approval
   ↓
Treatment Initiation
   ↓
Treatment Continuation / Discontinuation
Treatment Status Values
Started
Not Started
Discontinued
5. access_events.csv

Contains individual events related to the patient access process.

Column	Description	Data Type
event_id	Unique access-event identifier	Integer / ID
patient_id	Patient associated with the access event	Integer / ID
event_date	Date on which the event occurred	Date
event_type	Type of access event	Categorical
event_status	Status of the access event	Categorical
delay_days	Number of days associated with the event delay	Numeric
reason	Reason associated with the event	Categorical / Text
Primary Key
event_id
Relationship
patient_id → patients.patient_id
6. final_patient_analytics.csv

This is the main processed analytical dataset used for analysis and Power BI reporting.

It combines patient-level information with provider, therapy, treatment journey, access, and derived analytical attributes.

The dataset contains:

10,000 rows
30 columns
Important Analytical Fields
Patient Identifiers
Field	Description
patient_id	Unique patient identifier
provider_id	Healthcare provider identifier
therapy_id	Therapy identifier
Patient Dimensions
Field	Description
age_group	Patient age category
gender	Patient gender category
region	Patient geographic region
city	Patient city
insurance_type	Patient payer/insurance category
Therapy Dimensions
Field	Description
therapy_name	Therapy name
therapy_area	Therapeutic area
treatment_type	Treatment category
manufacturer	Therapy manufacturer
Provider Dimensions
Field	Description
provider_name	Provider name
specialty	Provider specialty
provider_type	Provider type
Treatment Journey Fields
Field	Description
diagnosis_date	Date of diagnosis
treatment_decision_date	Date of treatment decision
access_approval_date	Date of access approval
treatment_start_date	Treatment initiation date
treatment_status	Current treatment status
discontinuation_date	Treatment discontinuation date
discontinuation_reason	Reason for discontinuation
7. Derived Analytical Fields

The processed dataset also contains fields created during data preparation and feature engineering.

treatment_initiated_flag

Indicates whether the patient initiated treatment.

1 = Treatment initiated
0 = Treatment not initiated

Used to calculate:

Treatment Initiation Rate
discontinued_flag

Indicates whether the patient discontinued treatment.

1 = Discontinued
0 = Not discontinued

Used to calculate:

Discontinuation Rate
days_to_treatment

Number of days between diagnosis and treatment initiation.

Conceptually:

Treatment Start Date - Diagnosis Date

Used to calculate:

Average Days to Treatment
access_approval_days

Number of days associated with the access approval process.

Used to calculate:

Average Access Approval Days
access_delay_category

Categorizes patients/events based on access delay.

This field supports segmentation of access performance into more interpretable groups.

8. Key Relationships

The main dataset relationships can be represented as:

patients
    │
    ├── provider_id ──→ providers
    │
    └── therapy_id ───→ therapies
    │
    └── patient_id ───→ patient_journey
    │
    └── patient_id ───→ access_events

The processed analytical dataset brings these relationships together for reporting.

9. Key Business Dimensions

The dataset supports analysis across:

Patient
Age group
Gender
Region
City
Payer
Insurance type
Therapy
Therapy
Therapy area
Treatment type
Manufacturer
Provider
Provider
Specialty
Provider type
Region
Treatment Journey
Treatment status
Treatment initiation
Treatment discontinuation
Days to treatment
Access
Access approval
Approval duration
Delay category
Access-event status
10. Key Metrics Derived from the Dataset
Metric	Definition
Treatment Initiation Rate	Initiated patients ÷ total patients
Discontinuation Rate	Discontinued patients ÷ total patients
Average Days to Treatment	Average of days_to_treatment
Average Access Approval Days	Average of access_approval_days
Patient Volume	Count of patients
Access Event Volume	Count of access events
11. Data Notes
All records are synthetic.
patient_id, provider_id, therapy_id, and event_id are identifiers rather than analytical measures.
Date fields are used for journey and time-based analysis.
Treatment and discontinuation fields may contain missing dates when the corresponding event has not occurred.
Derived analytical fields are created for reporting and metric calculation.
The processed dataset is intended to provide a single analytical view for Power BI and downstream reporting.
12. Data Usage

The datasets support the following analytical areas:

Patient Treatment Access
        ↓
Treatment Initiation
        ↓
Treatment Timeline
        ↓
Access Approval
        ↓
Payer Analysis
        ↓
Therapy Analysis
        ↓
Regional Analysis
        ↓
Provider Performance

All analysis performed using these datasets is for demonstration and portfolio purposes.