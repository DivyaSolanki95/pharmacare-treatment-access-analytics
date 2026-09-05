-- ============================================================
-- PHARMACARE
-- PATIENT TREATMENT ACCESS & JOURNEY ANALYTICS
-- ============================================================
-- File: provider_analysis.sql
-- Purpose:
-- Evaluate treatment-access performance across healthcare
-- providers and identify potential operational variation.
--
-- Business objectives:
-- 1. Compare providers by patient volume
-- 2. Measure treatment initiation by provider
-- 3. Measure treatment-access time
-- 4. Identify providers with higher discontinuation
-- 5. Support targeted operational investigation
-- ============================================================


USE pharmacare;


-- ============================================================
-- ANALYSIS 1: PROVIDER PATIENT VOLUME
-- ============================================================

SELECT
    pr.provider_id,
    pr.provider_name,
    pr.region,
    pr.specialty,
    pr.provider_type,

    COUNT(p.patient_id) AS patient_count

FROM providers AS pr

LEFT JOIN patients AS p
    ON pr.provider_id = p.provider_id

GROUP BY
    pr.provider_id,
    pr.provider_name,
    pr.region,
    pr.specialty,
    pr.provider_type

ORDER BY patient_count DESC;


-- ============================================================
-- ANALYSIS 2: TREATMENT START RATE BY PROVIDER
-- ============================================================

SELECT
    pr.provider_id,
    pr.provider_name,
    pr.region,
    pr.specialty,

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
    ) AS treatment_start_rate_percent

FROM patients AS p

INNER JOIN providers AS pr
    ON p.provider_id = pr.provider_id

INNER JOIN patient_journey AS j
    ON p.patient_id = j.patient_id

GROUP BY
    pr.provider_id,
    pr.provider_name,
    pr.region,
    pr.specialty

ORDER BY treatment_start_rate_percent DESC;


-- ============================================================
-- ANALYSIS 3: TREATMENT ACCESS TIME BY PROVIDER
-- ============================================================

SELECT
    pr.provider_id,
    pr.provider_name,
    pr.region,
    pr.specialty,

    COUNT(*) AS treated_patients,

    ROUND(
        AVG(
            DATEDIFF(
                j.treatment_start_date,
                j.diagnosis_date
            )
        ),
        2
    ) AS average_days_to_treatment

FROM patients AS p

INNER JOIN providers AS pr
    ON p.provider_id = pr.provider_id

INNER JOIN patient_journey AS j
    ON p.patient_id = j.patient_id

WHERE j.treatment_start_date IS NOT NULL

GROUP BY
    pr.provider_id,
    pr.provider_name,
    pr.region,
    pr.specialty

ORDER BY average_days_to_treatment DESC;


-- ============================================================
-- ANALYSIS 4: DISCONTINUATION RATE BY PROVIDER
-- ============================================================

SELECT
    pr.provider_id,
    pr.provider_name,
    pr.region,
    pr.specialty,

    SUM(
        CASE
            WHEN j.treatment_status IN ('Started', 'Discontinued')
            THEN 1
            ELSE 0
        END
    ) AS treatment_started,

    SUM(
        CASE
            WHEN j.treatment_status = 'Discontinued'
            THEN 1
            ELSE 0
        END
    ) AS discontinued,

    ROUND(
        SUM(
            CASE
                WHEN j.treatment_status = 'Discontinued'
                THEN 1
                ELSE 0
            END
        ) * 100.0 /
        NULLIF(
            SUM(
                CASE
                    WHEN j.treatment_status IN ('Started', 'Discontinued')
                    THEN 1
                    ELSE 0
                END
            ),
            0
        ),
        2
    ) AS discontinuation_rate_percent

FROM patients AS p

INNER JOIN providers AS pr
    ON p.provider_id = pr.provider_id

INNER JOIN patient_journey AS j
    ON p.patient_id = j.patient_id

GROUP BY
    pr.provider_id,
    pr.provider_name,
    pr.region,
    pr.specialty

ORDER BY discontinuation_rate_percent DESC;


-- ============================================================
-- ANALYSIS 5: PROVIDER PERFORMANCE SUMMARY
-- ============================================================
-- Combines key treatment journey metrics into one view.

SELECT
    pr.provider_id,
    pr.provider_name,
    pr.region,
    pr.specialty,
    pr.provider_type,

    COUNT(*) AS total_patients,

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
            CASE
                WHEN j.treatment_start_date IS NOT NULL
                THEN DATEDIFF(
                    j.treatment_start_date,
                    j.diagnosis_date
                )
            END
        ),
        2
    ) AS average_days_to_treatment,

    ROUND(
        SUM(
            CASE
                WHEN j.treatment_status = 'Discontinued'
                THEN 1
                ELSE 0
            END
        ) * 100.0 /
        NULLIF(
            SUM(
                CASE
                    WHEN j.treatment_status IN ('Started', 'Discontinued')
                    THEN 1
                    ELSE 0
                END
            ),
            0
        ),
        2
    ) AS discontinuation_rate_percent

FROM patients AS p

INNER JOIN providers AS pr
    ON p.provider_id = pr.provider_id

INNER JOIN patient_journey AS j
    ON p.patient_id = j.patient_id

GROUP BY
    pr.provider_id,
    pr.provider_name,
    pr.region,
    pr.specialty,
    pr.provider_type

ORDER BY total_patients DESC;