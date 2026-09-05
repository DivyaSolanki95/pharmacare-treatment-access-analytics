-- ============================================================
-- PHARMACARE
-- PATIENT TREATMENT ACCESS & JOURNEY ANALYTICS
-- ============================================================
-- File: access_analysis.sql
-- Purpose:
-- Analyze access events to identify operational barriers,
-- delays and recurring reasons affecting treatment access.
--
-- Business objectives:
-- 1. Measure access-event volume
-- 2. Identify major access barriers
-- 3. Quantify delays by event type
-- 4. Compare access performance across regions
-- 5. Identify high-delay access events
-- ============================================================


USE pharmacare;


-- ============================================================
-- ANALYSIS 1: TOTAL ACCESS EVENTS
-- ============================================================

SELECT
    COUNT(*) AS total_access_events,
    COUNT(DISTINCT patient_id) AS patients_with_access_events
FROM access_events;


-- ============================================================
-- ANALYSIS 2: ACCESS EVENTS BY EVENT TYPE
-- ============================================================

SELECT
    event_type,
    COUNT(*) AS event_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM access_events),
        2
    ) AS percentage_of_events,

    ROUND(
        AVG(delay_days),
        2
    ) AS average_delay_days

FROM access_events

GROUP BY event_type

ORDER BY event_count DESC;


-- ============================================================
-- ANALYSIS 3: ACCESS EVENTS BY STATUS
-- ============================================================

SELECT
    event_status,
    COUNT(*) AS event_count,

    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM access_events),
        2
    ) AS percentage_of_events,

    ROUND(
        AVG(delay_days),
        2
    ) AS average_delay_days

FROM access_events

GROUP BY event_status

ORDER BY event_count DESC;


-- ============================================================
-- ANALYSIS 4: TOP ACCESS BARRIERS
-- ============================================================
-- Identifies the most frequently recorded reasons for
-- access-related events.

SELECT
    reason,
    COUNT(*) AS event_count,

    ROUND(
        AVG(delay_days),
        2
    ) AS average_delay_days,

    MAX(delay_days) AS maximum_delay_days

FROM access_events

GROUP BY reason

ORDER BY event_count DESC;


-- ============================================================
-- ANALYSIS 5: ACCESS BARRIERS BY REGION
-- ============================================================

SELECT
    p.region,

    COUNT(a.event_id) AS access_events,

    ROUND(
        AVG(a.delay_days),
        2
    ) AS average_delay_days,

    SUM(
        CASE
            WHEN a.delay_days > 20
            THEN 1
            ELSE 0
        END
    ) AS delayed_events,

    ROUND(
        SUM(
            CASE
                WHEN a.delay_days > 20
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(a.event_id),
        2
    ) AS delayed_event_rate_percent

FROM access_events AS a

INNER JOIN patients AS p
    ON a.patient_id = p.patient_id

GROUP BY p.region

ORDER BY average_delay_days DESC;


-- ============================================================
-- ANALYSIS 6: ACCESS BARRIERS BY INSURANCE TYPE
-- ============================================================

SELECT
    p.insurance_type,

    COUNT(a.event_id) AS access_events,

    ROUND(
        AVG(a.delay_days),
        2
    ) AS average_delay_days,

    SUM(
        CASE
            WHEN a.delay_days > 20
            THEN 1
            ELSE 0
        END
    ) AS delayed_events,

    ROUND(
        SUM(
            CASE
                WHEN a.delay_days > 20
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(a.event_id),
        2
    ) AS delayed_event_rate_percent

FROM access_events AS a

INNER JOIN patients AS p
    ON a.patient_id = p.patient_id

GROUP BY p.insurance_type

ORDER BY average_delay_days DESC;


-- ============================================================
-- ANALYSIS 7: HIGH-DELAY ACCESS EVENTS
-- ============================================================
-- Focuses on events with delays greater than 30 days.

SELECT
    event_type,
    reason,

    COUNT(*) AS high_delay_events,

    ROUND(
        AVG(delay_days),
        2
    ) AS average_delay_days,

    MAX(delay_days) AS maximum_delay_days

FROM access_events

WHERE delay_days > 30

GROUP BY
    event_type,
    reason

ORDER BY high_delay_events DESC;


-- ============================================================
-- ANALYSIS 8: TOP 10 PATIENT ACCESS DELAYS
-- ============================================================
-- Identifies the most extreme individual access delays
-- for investigation.

SELECT
    a.patient_id,
    p.region,
    p.insurance_type,
    a.event_type,
    a.event_status,
    a.delay_days,
    a.reason,
    a.event_date

FROM access_events AS a

INNER JOIN patients AS p
    ON a.patient_id = p.patient_id

ORDER BY a.delay_days DESC

LIMIT 10;