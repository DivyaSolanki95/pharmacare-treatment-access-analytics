-- ============================================================
-- PHARMACARE - DATABASE SCHEMA
-- ============================================================

CREATE DATABASE IF NOT EXISTS pharmacare;

USE pharmacare;


-- ============================================================
-- 1. PROVIDERS
-- ============================================================

DROP TABLE IF EXISTS access_events;
DROP TABLE IF EXISTS patient_journey;
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS therapies;
DROP TABLE IF EXISTS providers;


CREATE TABLE providers (
    provider_id VARCHAR(10) PRIMARY KEY,
    provider_name VARCHAR(100) NOT NULL,
    region VARCHAR(30) NOT NULL,
    specialty VARCHAR(50) NOT NULL,
    provider_type VARCHAR(50) NOT NULL
);


-- ============================================================
-- 2. THERAPIES
-- ============================================================

CREATE TABLE therapies (
    therapy_id VARCHAR(10) PRIMARY KEY,
    therapy_name VARCHAR(100) NOT NULL,
    therapy_area VARCHAR(50) NOT NULL,
    treatment_type VARCHAR(50) NOT NULL,
    manufacturer VARCHAR(100) NOT NULL
);


-- ============================================================
-- 3. PATIENTS
-- ============================================================

CREATE TABLE patients (
    patient_id VARCHAR(10) PRIMARY KEY,
    age_group VARCHAR(20) NOT NULL,
    gender VARCHAR(20) NOT NULL,
    region VARCHAR(30) NOT NULL,
    city VARCHAR(50) NOT NULL,
    insurance_type VARCHAR(50) NOT NULL,
    provider_id VARCHAR(10) NOT NULL,
    therapy_id VARCHAR(10) NOT NULL,
    diagnosis_date DATE NOT NULL,

    CONSTRAINT fk_patient_provider
        FOREIGN KEY (provider_id)
        REFERENCES providers(provider_id),

    CONSTRAINT fk_patient_therapy
        FOREIGN KEY (therapy_id)
        REFERENCES therapies(therapy_id)
);


-- ============================================================
-- 4. PATIENT JOURNEY
-- ============================================================

CREATE TABLE patient_journey (
    patient_id VARCHAR(10) PRIMARY KEY,
    diagnosis_date DATE NOT NULL,
    treatment_decision_date DATE NOT NULL,
    access_approval_date DATE NOT NULL,
    treatment_start_date DATE NULL,
    treatment_status VARCHAR(30) NOT NULL,
    discontinuation_date DATE NULL,
    discontinuation_reason VARCHAR(100) NULL,

    CONSTRAINT fk_journey_patient
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id)
);


-- ============================================================
-- 5. ACCESS EVENTS
-- ============================================================

CREATE TABLE access_events (
    event_id VARCHAR(20) PRIMARY KEY,
    patient_id VARCHAR(10) NOT NULL,
    event_date DATE NOT NULL,
    event_type VARCHAR(50) NOT NULL,
    event_status VARCHAR(30) NOT NULL,
    delay_days INT NOT NULL,
    reason VARCHAR(100) NOT NULL,

    CONSTRAINT fk_event_patient
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id)
);


-- ============================================================
-- VERIFY TABLES
-- ============================================================

SHOW TABLES;