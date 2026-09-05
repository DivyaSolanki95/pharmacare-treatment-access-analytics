-- ============================================================
-- PHARMACARE
-- PATIENT TREATMENT ACCESS & JOURNEY ANALYTICS
-- ============================================================
-- File: patient_journey.sql
-- Purpose:
-- Analyze patient progression from diagnosis to treatment.
--
-- Business objectives:
-- 1. Measure treatment journey conversion
-- 2. Identify patient drop-offs
-- 3. Measure treatment initiation
-- 4. Measure treatment discontinuation
-- 5. Quantify time to treatment
-- 6. Compare journey performance across therapy areas
-- ============================================================


USE pharmacare;


-- ============================================================
-- ANALYSIS 1: PATIENT JOURNEY FUNNEL
-- ============================================================
-- Shows how patients progress through the treatment journey.

SELECT
    COUNT(*) AS diagnosed_patients,

    SUM(
        CASE
            WHEN treatment_status IN ('Started', 'Discontinued')
            THEN 1
            ELSE 0
        END
    ) AS treatment_started_patients,

    SUM(
        CASE
            WHEN treatment_status = 'Discontinued'
            THEN 1
            ELSE 0
        END
    ) AS discontinued_patients,

    SUM(
        CASE
            WHEN treatment_status = 'Not Started'
            THEN 1
            ELSE 0
        END
    ) AS treatment_not_started_patients

FROM patient_journey;


-- ============================================================
-- ANALYSIS 2: TREATMENT START RATE
-- ============================================================
-- Measures the percentage of diagnosed patients who
-- eventually started treatment.

SELECT
    COUNT(*) AS total_patients,

    SUM(
        CASE
            WHEN treatment_status IN ('Started', 'Discontinued')
            THEN 1
            ELSE 0
        END
    ) AS patients_started,

    ROUND(
        SUM(
            CASE
                WHEN treatment_status IN ('Started', 'Discontinued')
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS treatment_start_rate_percent

FROM patient_journey;


-- ============================================================
-- ANALYSIS 3: TREATMENT DISCONTINUATION RATE
-- ============================================================
-- Measures discontinuation among patients who started treatment.

SELECT
    SUM(
        CASE
            WHEN treatment_status IN ('Started', 'Discontinued')
            THEN 1
            ELSE 0
        END
    ) AS treatment_started,

    SUM(
        CASE
            WHEN treatment_status = 'Discontinued'
            THEN 1
            ELSE 0
        END
    ) AS discontinued,

    ROUND(
        SUM(
            CASE
                WHEN treatment_status = 'Discontinued'
                THEN 1
                ELSE 0
            END
        ) * 100.0 /
        NULLIF(
            SUM(
                CASE
                    WHEN treatment_status IN ('Started', 'Discontinued')
                    THEN 1
                    ELSE 0
                END
            ),
            0
        ),
        2
    ) AS discontinuation_rate_percent

FROM patient_journey;


-- ============================================================
-- ANALYSIS 4: TIME FROM DIAGNOSIS TO TREATMENT
-- ============================================================
-- Measures how long patients who started treatment waited
-- from diagnosis to treatment initiation.

SELECT
    ROUND(
        AVG(
            DATEDIFF(
                treatment_start_date,
                diagnosis_date
            )
        ),
        2
    ) AS average_days_to_treatment,

    ROUND(
        AVG(
            DATEDIFF(
                treatment_start_date,
                diagnosis_date
            )
        ),
        2
    ) AS mean_days_to_treatment,

    MIN(
        DATEDIFF(
            treatment_start_date,
            diagnosis_date
        )
    ) AS minimum_days_to_treatment,

    MAX(
        DATEDIFF(
            treatment_start_date,
            diagnosis_date
        )
    ) AS maximum_days_to_treatment

FROM patient_journey

WHERE treatment_start_date IS NOT NULL;


-- ============================================================
-- ANALYSIS 5: TIME TO TREATMENT BY THERAPY AREA
-- ============================================================
-- Identifies therapy areas with longer treatment-access
-- timelines.

SELECT
    t.therapy_area,

    COUNT(*) AS total_patients,

    SUM(
        CASE
            WHEN j.treatment_status IN ('Started', 'Discontinued')
            THEN 1
            ELSE 0
        END
    ) AS patients_started,

    ROUND(
        SUM(
            CASE
                WHEN j.treatment_status IN ('Started', 'Discontinued')
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS treatment_start_rate_percent,

    ROUND(
        AVG(
            DATEDIFF(
                j.treatment_start_date,
                j.diagnosis_date
            )
        ),
        2
    ) AS average_days_to_treatment

FROM patient_journey AS j

INNER JOIN patients AS p
    ON j.patient_id = p.patient_id

INNER JOIN therapies AS t
    ON p.therapy_id = t.therapy_id

GROUP BY t.therapy_area

ORDER BY average_days_to_treatment DESC;


-- ============================================================
-- ANALYSIS 6: TREATMENT STATUS BY REGION
-- ============================================================
-- Compares treatment outcomes across geographic regions.

SELECT
    p.region,

    COUNT(*) AS total_patients,

    SUM(
        CASE
            WHEN j.treatment_status IN ('Started', 'Discontinued')
            THEN 1
            ELSE 0
        END
    ) AS patients_started,

    SUM(
        CASE
            WHEN j.treatment_status = 'Not Started'
            THEN 1
            ELSE 0
        END
    ) AS patients_not_started,

    SUM(
        CASE
            WHEN j.treatment_status = 'Discontinued'
            THEN 1
            ELSE 0
        END
    ) AS patients_discontinued,

    ROUND(
        SUM(
            CASE
                WHEN j.treatment_status IN ('Started', 'Discontinued')
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS treatment_start_rate_percent

FROM patient_journey AS j

INNER JOIN patients AS p
    ON j.patient_id = p.patient_id

GROUP BY p.region

ORDER BY treatment_start_rate_percent DESC;


-- ============================================================
-- ANALYSIS 7: ACCESS DELAY BY INSURANCE TYPE
-- ============================================================
-- Evaluates whether payer type is associated with longer
-- treatment-access timelines.

SELECT
    p.insurance_type,

    COUNT(*) AS total_patients,

    ROUND(
        AVG(
            DATEDIFF(
                j.access_approval_date,
                j.treatment_decision_date
            )
        ),
        2
    ) AS average_access_approval_days,

    ROUND(
        AVG(
            DATEDIFF(
                j.treatment_start_date,
                j.diagnosis_date
            )
        ),
        2
    ) AS average_days_to_treatment

FROM patient_journey AS j

INNER JOIN patients AS p
    ON j.patient_id = p.patient_id

GROUP BY p.insurance_type

ORDER BY average_access_approval_days DESC;


-- ============================================================
-- ANALYSIS 8: LONG ACCESS DELAYS
-- ============================================================
-- Identifies patients experiencing more than 30 days
-- between treatment decision and access approval.

SELECT
    COUNT(*) AS patients_with_long_access_delay,

    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM patient_journey),
        2
    ) AS percentage_of_patients

FROM patient_journey

WHERE DATEDIFF(
    access_approval_date,
    treatment_decision_date
) > 30;