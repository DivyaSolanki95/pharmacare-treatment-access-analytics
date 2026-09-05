-- ============================================================
-- PHARMACARE
-- PATIENT TREATMENT ACCESS & JOURNEY ANALYTICS
-- ============================================================
-- File: executive_summary.sql
-- Purpose:
-- Create the core executive KPIs for reporting and
-- decision-oriented analysis.
-- ============================================================

USE pharmacare;


-- ============================================================
-- EXECUTIVE KPI SUMMARY
-- ============================================================

SELECT

    -- Patient population
    COUNT(*) AS diagnosed_patients,

    -- Patients who initiated treatment
    SUM(
        CASE
            WHEN treatment_status IN ('Started', 'Discontinued')
            THEN 1
            ELSE 0
        END
    ) AS treatment_initiated_patients,

    -- Patients who did not initiate treatment
    SUM(
        CASE
            WHEN treatment_status = 'Not Started'
            THEN 1
            ELSE 0
        END
    ) AS treatment_not_started,

    -- Treatment initiation rate
    ROUND(
        SUM(
            CASE
                WHEN treatment_status IN ('Started', 'Discontinued')
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS treatment_initiation_rate_percent,

    -- Discontinued patients
    SUM(
        CASE
            WHEN treatment_status = 'Discontinued'
            THEN 1
            ELSE 0
        END
    ) AS discontinued_patients,

    -- Discontinuation rate among treatment initiators
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
    ) AS discontinuation_rate_percent,

    -- Average diagnosis-to-treatment time
    ROUND(
        AVG(
            CASE
                WHEN treatment_start_date IS NOT NULL
                THEN DATEDIFF(
                    treatment_start_date,
                    diagnosis_date
                )
            END
        ),
        2
    ) AS average_days_to_treatment,

    -- Patients experiencing >30 days to access approval
    (
        SELECT COUNT(*)
        FROM patient_journey
        WHERE DATEDIFF(
            access_approval_date,
            treatment_decision_date
        ) > 30
    ) AS long_access_delay_patients

FROM patient_journey;


-- ============================================================
-- EXECUTIVE VIEW: THERAPY PERFORMANCE
-- ============================================================

SELECT
    t.therapy_area,

    COUNT(*) AS patients,

    ROUND(
        SUM(
            CASE
                WHEN j.treatment_status IN ('Started', 'Discontinued')
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS treatment_initiation_rate_percent,

    ROUND(
        AVG(
            CASE
                WHEN j.treatment_start_date IS NOT NULL
                THEN DATEDIFF(
                    j.treatment_start_date,
                    j.diagnosis_date
                )
            END
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
-- EXECUTIVE VIEW: INSURANCE PERFORMANCE
-- ============================================================

SELECT
    p.insurance_type,

    COUNT(*) AS patients,

    ROUND(
        SUM(
            CASE
                WHEN j.treatment_status IN ('Started', 'Discontinued')
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS treatment_initiation_rate_percent,

    ROUND(
        AVG(
            CASE
                WHEN j.treatment_start_date IS NOT NULL
                THEN DATEDIFF(
                    j.treatment_start_date,
                    j.diagnosis_date
                )
            END
        ),
        2
    ) AS average_days_to_treatment

FROM patient_journey AS j

INNER JOIN patients AS p
    ON j.patient_id = p.patient_id

GROUP BY p.insurance_type

ORDER BY average_days_to_treatment DESC;