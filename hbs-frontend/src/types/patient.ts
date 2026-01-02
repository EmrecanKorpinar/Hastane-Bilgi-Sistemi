// Patient types
export interface Patient {
  patientId: string;
  nationalId: string;
  fileNumber: string;
  name: string;
  surname: string;
  fullName: string;
  birthDate: string;
  gender: 'MALE' | 'FEMALE' | 'OTHER';
  phone?: string;
  email?: string;
  address?: string;
  city?: string;
  country?: string;
  bloodType?: string;
  emergencyContact?: string;
  emergencyPhone?: string;
  active: boolean;
  createdAt: string;
  updatedAt?: string;
}

export interface CreatePatientRequest {
  nationalId: string;
  name: string;
  surname: string;
  birthDate: string;
  gender: 'MALE' | 'FEMALE' | 'OTHER';
  phone?: string;
  email?: string;
  address?: string;
  city?: string;
  country?: string;
  bloodType?: string;
  emergencyContact?: string;
  emergencyPhone?: string;
}

export interface ErrorResponse {
  errorCode: string;
  message: string;
  path: string;
  timestamp: string;
  traceId: string;
  details?: Record<string, any>;
}

