-- ============================================================
-- PHARMACARE
-- PATIENT TREATMENT ACCESS & JOURNEY ANALYTICS
-- ============================================================
-- File: final_reporting_dataset.sql
-- Purpose: Create the final patient-level reporting dataset
-- for Power BI and executive analysis.
-- ============================================================

USE pharmacare;

DROP TABLE IF EXISTS final_patient_analytics;


CREATE TABLE final_patient_analytics AS

SELECT

    -- --------------------------------------------------------
    -- PATIENT INFORMATION
    -- --------------------------------------------------------

    p.patient_id,
    p.age_group,
    p.gender,
    p.region,
    p.city,
    p.insurance_type,

    -- --------------------------------------------------------
    -- PROVIDER INFORMATION
    -- --------------------------------------------------------

    p.provider_id,
    pr.provider_name,
    pr.specialty,
    pr.provider_type,

    -- --------------------------------------------------------
    -- THERAPY INFORMATION
    -- --------------------------------------------------------

    p.therapy_id,
    t.therapy_name,
    t.therapy_area,
    t.treatment_type,
    t.manufacturer,

    -- --------------------------------------------------------
    -- PATIENT JOURNEY
    -- --------------------------------------------------------

    j.diagnosis_date,
    j.treatment_decision_date,
    j.access_approval_date,
    j.treatment_start_date,

    j.treatment_status,

    j.discontinuation_date,
    j.discontinuation_reason,

    -- --------------------------------------------------------
    -- JOURNEY TIMING
    -- --------------------------------------------------------

    DATEDIFF(
        j.treatment_decision_date,
        j.diagnosis_date
    ) AS days_to_treatment_decision,

    DATEDIFF(
        j.access_approval_date,
        j.treatment_decision_date
    ) AS access_approval_days,

    DATEDIFF(
        j.treatment_start_date,
        j.diagnosis_date
    ) AS days_to_treatment,

    -- --------------------------------------------------------
    -- ACCESS DELAY CATEGORY
    -- --------------------------------------------------------

    CASE

        WHEN DATEDIFF(
            j.access_approval_date,
            j.treatment_decision_date
        ) <= 10
        THEN '0-10 Days'

        WHEN DATEDIFF(
            j.access_approval_date,
            j.treatment_decision_date
        ) <= 20
        THEN '11-20 Days'

        WHEN DATEDIFF(
            j.access_approval_date,
            j.treatment_decision_date
        ) <= 30
        THEN '21-30 Days'

        ELSE '30+ Days'

    END AS access_delay_category,

    -- --------------------------------------------------------
    -- BUSINESS FLAGS
    -- --------------------------------------------------------

    CASE
        WHEN j.treatment_status IN ('Started', 'Discontinued')
        THEN 1
        ELSE 0
    END AS treatment_initiated_flag,

    CASE
        WHEN j.treatment_status = 'Not Started'
        THEN 1
        ELSE 0
    END AS treatment_not_started_flag,

    CASE
        WHEN j.treatment_status = 'Discontinued'
        THEN 1
        ELSE 0
    END AS discontinued_flag,

    CASE
        WHEN DATEDIFF(
            j.access_approval_date,
            j.treatment_decision_date
        ) > 30
        THEN 1
        ELSE 0
    END AS long_access_delay_flag

FROM patients AS p

LEFT JOIN providers AS pr
    ON p.provider_id = pr.provider_id

LEFT JOIN therapies AS t
    ON p.therapy_id = t.therapy_id

LEFT JOIN patient_journey AS j
    ON p.patient_id = j.patient_id;


-- ============================================================
-- VALIDATION
-- ============================================================

SELECT
    COUNT(*) AS total_patients
FROM final_patient_analytics;


SELECT
    COUNT(DISTINCT patient_id) AS unique_patients
FROM final_patient_analytics;


SELECT
    treatment_status,
    COUNT(*) AS patient_count
FROM final_patient_analytics
GROUP BY treatment_status
ORDER BY patient_count DESC;


SELECT
    COUNT(*) AS patients_with_long_access_delay
FROM final_patient_analytics
WHERE long_access_delay_flag = 1;


-- ============================================================
-- FINAL DATASET PREVIEW
-- ============================================================

SELECT *
FROM final_patient_analytics
LIMIT 10;