import apiClient from './client';
import { Patient, CreatePatientRequest } from '../types/patient';

const PATIENT_API = '/api/patient';

export const patientService = {
  // Create new patient
  createPatient: async (data: CreatePatientRequest): Promise<Patient> => {
    const response = await apiClient.post<Patient>(PATIENT_API, data);
    return response.data;
  },

  // Get patient by ID
  getPatientById: async (patientId: string): Promise<Patient> => {
    const response = await apiClient.get<Patient>(`${PATIENT_API}/${patientId}`);
    return response.data;
  },

  // Get patient by national ID
  getPatientByNationalId: async (nationalId: string): Promise<Patient> => {
    const response = await apiClient.get<Patient>(`${PATIENT_API}/national-id/${nationalId}`);
    return response.data;
  },

  // Get patient by file number
  getPatientByFileNumber: async (fileNumber: string): Promise<Patient> => {
    const response = await apiClient.get<Patient>(`${PATIENT_API}/file-number/${fileNumber}`);
    return response.data;
  },

  // Search patients
  searchPatients: async (query: string): Promise<Patient[]> => {
    const response = await apiClient.get<Patient[]>(`${PATIENT_API}/search`, {
      params: { query },
    });
    return response.data;
  },

  // Get all active patients
  getActivePatients: async (): Promise<Patient[]> => {
    const response = await apiClient.get<Patient[]>(`${PATIENT_API}/active`);
    return response.data;
  },
};

