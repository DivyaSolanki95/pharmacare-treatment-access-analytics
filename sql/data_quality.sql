-- ============================================================
-- PHARMACARE
-- PATIENT TREATMENT ACCESS & JOURNEY ANALYTICS
-- ============================================================
-- File: data_quality.sql
-- Purpose:
-- Validate data integrity before analytical reporting.
--
-- The checks below verify:
-- 1. Duplicate patient records
-- 2. Referential integrity
-- 3. Valid treatment journey dates
-- 4. Treatment status completeness
-- 5. Overall dataset integrity
-- ============================================================


USE pharmacare;


-- ============================================================
-- CHECK 1: DUPLICATE PATIENT RECORDS
-- ============================================================
-- Each patient should appear exactly once in the patients table.
-- Expected result: No rows.

SELECT
    patient_id,
    COUNT(*) AS record_count
FROM patients
GROUP BY patient_id
HAVING COUNT(*) > 1;


-- ============================================================
-- CHECK 2: INVALID PROVIDER REFERENCES
-- ============================================================
-- Every patient must be associated with an existing provider.
-- Expected result: No rows.

SELECT
    p.patient_id,
    p.provider_id
FROM patients AS p
LEFT JOIN providers AS pr
    ON p.provider_id = pr.provider_id
WHERE pr.provider_id IS NULL;


-- ============================================================
-- CHECK 3: INVALID THERAPY REFERENCES
-- ============================================================
-- Every patient must be associated with an existing therapy.
-- Expected result: No rows.

SELECT
    p.patient_id,
    p.therapy_id
FROM patients AS p
LEFT JOIN therapies AS t
    ON p.therapy_id = t.therapy_id
WHERE t.therapy_id IS NULL;


-- ============================================================
-- CHECK 4: INVALID PATIENT JOURNEY REFERENCES
-- ============================================================
-- Every journey record must belong to a valid patient.
-- Expected result: No rows.

SELECT
    j.patient_id
FROM patient_journey AS j
LEFT JOIN patients AS p
    ON j.patient_id = p.patient_id
WHERE p.patient_id IS NULL;


-- ============================================================
-- CHECK 5: INVALID ACCESS EVENT REFERENCES
-- ============================================================
-- Every access event must belong to a valid patient.
-- Expected result: No rows.

SELECT
    a.event_id,
    a.patient_id
FROM access_events AS a
LEFT JOIN patients AS p
    ON a.patient_id = p.patient_id
WHERE p.patient_id IS NULL;


-- ============================================================
-- CHECK 6: INVALID TREATMENT JOURNEY DATES
-- ============================================================
-- Treatment cannot start before diagnosis.
-- Expected result: 0.

SELECT
    COUNT(*) AS invalid_treatment_dates
FROM patient_journey
WHERE treatment_start_date IS NOT NULL
  AND treatment_start_date < diagnosis_date;


-- ============================================================
-- CHECK 7: INVALID ACCESS APPROVAL DATES
-- ============================================================
-- Access approval cannot occur before the treatment decision.
-- Expected result: 0.

SELECT
    COUNT(*) AS invalid_approval_dates
FROM patient_journey
WHERE access_approval_date < treatment_decision_date;


-- ============================================================
-- CHECK 8: TREATMENT STATUS DISTRIBUTION
-- ============================================================
-- Provides a high-level completeness check for treatment outcomes.

SELECT
    treatment_status,
    COUNT(*) AS patient_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM patient_journey),
        2
    ) AS percentage_of_patients
FROM patient_journey
GROUP BY treatment_status
ORDER BY patient_count DESC;


-- ============================================================
-- CHECK 9: TREATMENT DATE CONSISTENCY
-- ============================================================
-- Patients who started treatment should have a treatment date.
-- Patients who did not start treatment should not have one.

SELECT
    treatment_status,
    COUNT(*) AS inconsistent_records
FROM patient_journey
WHERE
    (
        treatment_status IN ('Started', 'Discontinued')
        AND treatment_start_date IS NULL
    )
    OR
    (
        treatment_status = 'Not Started'
        AND treatment_start_date IS NOT NULL
    )
GROUP BY treatment_status;


-- ============================================================
-- CHECK 10: DATASET SIZE SUMMARY
-- ============================================================
-- Final record-count verification before analytical work.

SELECT
    (SELECT COUNT(*) FROM patients) AS patients,
    (SELECT COUNT(*) FROM providers) AS providers,
    (SELECT COUNT(*) FROM therapies) AS therapies,
    (SELECT COUNT(*) FROM patient_journey) AS patient_journeys,
    (SELECT COUNT(*) FROM access_events) AS access_events;