# PharmaCare — Data Dictionary

## Overview

The PharmaCare project uses multiple synthetic healthcare datasets representing patients, providers, therapies, treatment journeys, and access events.

The datasets are connected through common identifiers and are integrated into the processed analytical dataset:

```text
data/processed/final_patient_analytics.csv

All data used in this project is synthetic and intended for analytics demonstration purposes.

1. patients.csv

Contains the core patient population and demographic, geographic, insurance, provider, and therapy information.

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

Key Dimensions
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

Provider data supports analysis of:

Patient volume
Treatment initiation
Treatment timelines
Provider-level performance variation
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

Therapy Areas

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

The conceptual treatment journey is:

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

Dataset Size
Rows: 10,000
Columns: 30
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

The processed dataset includes analytical fields created during data preparation and feature engineering.

treatment_initiated_flag

Indicates whether the patient initiated treatment.

Value	Meaning
1	Treatment initiated
0	Treatment not initiated

Used to calculate:

Treatment Initiation Rate

discontinued_flag

Indicates whether the patient discontinued treatment.

Value	Meaning
1	Discontinued
0	Not discontinued

Used to calculate:

Discontinuation Rate

days_to_treatment

Measures the number of days between diagnosis and treatment initiation.

Conceptually:

Treatment Start Date - Diagnosis Date

Used to calculate:

Average Days to Treatment

access_approval_days

Measures the number of days associated with the access approval process.

Used to calculate:

Average Access Approval Days

access_delay_category

Categorizes access delays into analytical groups.

This field supports segmentation and comparison of access performance.

8. Key Relationships

The primary relationships between the datasets are:

patients
    │
    ├── provider_id ──→ providers.provider_id
    │
    ├── therapy_id ───→ therapies.therapy_id
    │
    ├── patient_id ───→ patient_journey.patient_id
    │
    └── patient_id ───→ access_events.patient_id

The processed analytical dataset brings the relevant patient, provider, therapy, journey, and access attributes together for reporting.


# 9. Key Business Dimensions

The datasets support analysis across the following dimensions.

## Patient

- Age group
- Gender
- Region
- City

## Payer

- Insurance type

## Therapy

- Therapy area
- Treatment type
- Manufacturer

## Provider

- Provider
- Specialty
- Provider type
- Region

## Treatment Journey

- Treatment status
- Treatment initiation
- Treatment discontinuation
- Days to treatment

## Access

- Access approval
- Approval duration
- Delay category
- Access-event status

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
Date fields are used for treatment journey and time-based analysis.
Treatment and discontinuation dates may be missing when the corresponding event has not occurred.
Derived analytical fields are created for reporting and metric calculation.
The processed dataset provides a consolidated analytical view for Power BI and downstream analysis.
12. Data Usage

The datasets support analysis of the complete treatment-access workflow:

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

The data dictionary provides a reference for understanding the structure, relationships, dimensions, and analytical fields used throughout the PharmaCare project.

All analysis performed using these datasets is for demonstration and portfolio purposes.