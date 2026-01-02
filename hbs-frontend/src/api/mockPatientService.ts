// Mock Patient Service - Backend olmadan çalışır
import { Patient, CreatePatientRequest, PatientResponse } from '../types/patient';

// LocalStorage'dan hastaları oku
function getPatients(): Patient[] {
  const data = localStorage.getItem('hbs-patients');
  return data ? JSON.parse(data) : [];
}

// LocalStorage'a hastaları yaz
function savePatients(patients: Patient[]): void {
  localStorage.setItem('hbs-patients', JSON.stringify(patients));
}

// Dosya numarası oluştur
function generateFileNumber(): string {
  const year = new Date().getFullYear();
  const patients = getPatients();
  const count = patients.length + 1;
  return `HBS-${year}-${String(count).padStart(6, '0')}`;
}

// UUID oluştur
function generateId(): string {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    const r = Math.random() * 16 | 0;
    const v = c === 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}

export const mockPatientService = {
  // Yeni hasta oluştur
  createPatient: async (request: CreatePatientRequest): Promise<PatientResponse> => {
    // 500ms simüle delay
    await new Promise(resolve => setTimeout(resolve, 500));

    const patients = getPatients();

    // TC Kimlik kontrolü
    const existingPatient = patients.find(p => p.nationalId === request.nationalId);
    if (existingPatient) {
      throw new Error('Bu TC Kimlik No ile kayıtlı hasta zaten mevcut!');
    }

    const patientId = generateId();
    const fileNumber = generateFileNumber();
    const fullName = `${request.name} ${request.surname}`;

    const newPatient: Patient = {
      patientId,
      fileNumber,
      nationalId: request.nationalId,
      name: request.name,
      surname: request.surname,
      fullName,
      birthDate: request.birthDate,
      gender: request.gender,
      bloodType: request.bloodType,
      phone: request.phone,
      email: request.email,
      address: request.address,
      city: request.city,
      country: request.country || 'Türkiye',
      active: true,
      emergencyContact: request.emergencyContact,
      emergencyPhone: request.emergencyPhone,
    };

    patients.push(newPatient);
    savePatients(patients);

    return {
      patientId,
      fileNumber,
      nationalId: request.nationalId,
      fullName,
      birthDate: request.birthDate,
      gender: request.gender,
      phone: request.phone,
      email: request.email,
      city: request.city,
      bloodType: request.bloodType,
      active: true,
    };
  },

  // Aktif hastaları getir
  getActivePatients: async (): Promise<Patient[]> => {
    await new Promise(resolve => setTimeout(resolve, 300));
    const patients = getPatients();
    return patients.filter(p => p.active);
  },

  // Hasta ara
  searchPatients: async (query: string): Promise<Patient[]> => {
    await new Promise(resolve => setTimeout(resolve, 300));
    const patients = getPatients();
    const lowerQuery = query.toLowerCase();

    return patients.filter(p =>
      p.fullName.toLowerCase().includes(lowerQuery) ||
      p.nationalId.includes(query) ||
      (p.phone && p.phone.includes(query)) ||
      (p.email && p.email.toLowerCase().includes(lowerQuery))
    );
  },

  // Hasta detayı getir
  getPatientById: async (patientId: string): Promise<Patient | null> => {
    await new Promise(resolve => setTimeout(resolve, 300));
    const patients = getPatients();
    return patients.find(p => p.patientId === patientId) || null;
  },
};

// Demo data ekle (ilk çalıştırmada)
export function initializeDemoData() {
  const patients = getPatients();
  if (patients.length === 0) {
    const demoPatients: Patient[] = [
      {
        patientId: generateId(),
        fileNumber: 'HBS-2026-000001',
        nationalId: '12345678901',
        name: 'Ahmet',
        surname: 'Yılmaz',
        fullName: 'Ahmet Yılmaz',
        birthDate: '1985-03-15',
        gender: 'MALE',
        bloodType: 'A+',
        phone: '+905551234567',
        email: 'ahmet.yilmaz@example.com',
        address: 'Kadıköy Mahallesi, Bahariye Caddesi No:123',
        city: 'İstanbul',
        country: 'Türkiye',
        active: true,
        emergencyContact: 'Ayşe Yılmaz',
        emergencyPhone: '+905559876543',
      },
      {
        patientId: generateId(),
        fileNumber: 'HBS-2026-000002',
        nationalId: '98765432101',
        name: 'Fatma',
        surname: 'Demir',
        fullName: 'Fatma Demir',
        birthDate: '1992-07-22',
        gender: 'FEMALE',
        bloodType: 'B+',
        phone: '+905551112233',
        email: 'fatma.demir@example.com',
        address: 'Çankaya Mahallesi, Atatürk Bulvarı No:45',
        city: 'Ankara',
        country: 'Türkiye',
        active: true,
      },
      {
        patientId: generateId(),
        fileNumber: 'HBS-2026-000003',
        nationalId: '11122233344',
        name: 'Mehmet',
        surname: 'Kaya',
        fullName: 'Mehmet Kaya',
        birthDate: '1978-11-05',
        gender: 'MALE',
        bloodType: '0+',
        phone: '+905554445566',
        email: 'mehmet.kaya@example.com',
        city: 'İzmir',
        country: 'Türkiye',
        active: true,
      },
    ];
    savePatients(demoPatients);
  }
}

