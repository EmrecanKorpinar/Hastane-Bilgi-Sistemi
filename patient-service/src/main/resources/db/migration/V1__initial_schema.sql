-- Patient Service Database Schema
-- Version: V1__initial_schema.sql

CREATE TABLE IF NOT EXISTS patients (
    patient_id VARCHAR(36) PRIMARY KEY,
    national_id VARCHAR(11) NOT NULL UNIQUE,
    file_number VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL,
    gender VARCHAR(10) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    address VARCHAR(500),
    city VARCHAR(50),
    country VARCHAR(50),
    blood_type VARCHAR(5),
    emergency_contact VARCHAR(100),
    emergency_phone VARCHAR(20),
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    version BIGINT DEFAULT 0
);

-- Indexes
CREATE INDEX idx_national_id ON patients(national_id);
CREATE INDEX idx_file_number ON patients(file_number);
CREATE INDEX idx_phone ON patients(phone);
CREATE INDEX idx_name_surname ON patients(name, surname);
CREATE INDEX idx_active ON patients(active);

-- Comments
COMMENT ON TABLE patients IS 'Patient aggregate root - stores patient demographic information';
COMMENT ON COLUMN patients.patient_id IS 'Unique identifier (UUID)';
COMMENT ON COLUMN patients.national_id IS 'Turkish National ID (TC Kimlik No) - 11 digits';
COMMENT ON COLUMN patients.file_number IS 'Hospital file number (HBS-YYYY-NNNNNN)';
COMMENT ON COLUMN patients.version IS 'Optimistic locking version';

