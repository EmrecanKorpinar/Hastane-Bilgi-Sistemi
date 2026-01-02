import React, { useState, useEffect } from 'react';
import { Search, Loader2, Users, AlertCircle, RefreshCw } from 'lucide-react';
import { mockPatientService } from '../api/mockPatientService';
import { Patient } from '../types/patient';
import dayjs from 'dayjs';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from './ui/card';
import { Input } from './ui/input';
import { Button } from './ui/button';
import { useToast } from '../hooks/use-toast';

const PatientList: React.FC = () => {
  const [patients, setPatients] = useState<Patient[]>([]);
  const [loading, setLoading] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const { toast } = useToast();

  useEffect(() => {
    loadActivePatients();
  }, []);

  const loadActivePatients = async () => {
    setLoading(true);
    try {
      const data = await mockPatientService.getActivePatients();
      setPatients(data);
    } catch (error) {
      toast({
        variant: "destructive",
        title: "❌ Hata",
        description: 'Hastalar yüklenirken hata oluştu',
      });
      console.error('Error loading patients:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleSearch = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!searchQuery.trim()) {
      loadActivePatients();
      return;
    }

    setLoading(true);
    try {
      const data = await mockPatientService.searchPatients(searchQuery);
      setPatients(data);
      toast({
        title: "🔍 Arama tamamlandı",
        description: `${data.length} hasta bulundu`,
      });
    } catch (error) {
      toast({
        variant: "destructive",
        title: "❌ Hata",
        description: 'Arama sırasında hata oluştu',
      });
      console.error('Error searching patients:', error);
    } finally {
      setLoading(false);
    }
  };

  const getGenderLabel = (gender: string): string => {
    const genderMap: Record<string, string> = {
      MALE: 'Erkek',
      FEMALE: 'Kadın',
      OTHER: 'Diğer',
    };
    return genderMap[gender] || gender;
  };

  return (
    <div className="max-w-7xl mx-auto">
      <Card className="border-2 shadow-xl">
        <CardHeader className="bg-gradient-to-r from-indigo-50 to-purple-50 border-b">
          <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
            <div className="flex items-center space-x-3">
              <div className="p-2 bg-indigo-600 rounded-lg">
                <Users className="text-white" size={24} />
              </div>
              <div>
                <CardTitle className="text-2xl">Hasta Listesi</CardTitle>
                <CardDescription className="text-base mt-1">
                  Toplam {patients.length} hasta kaydı
                </CardDescription>
              </div>
            </div>

            <form onSubmit={handleSearch} className="flex gap-2">
              <Input
                type="text"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Ad, soyad, TC ile ara..."
                className="w-64"
              />
              <Button type="submit" disabled={loading} variant="default">
                <Search className="mr-2 h-4 w-4" />
                Ara
              </Button>
              <Button
                type="button"
                onClick={loadActivePatients}
                disabled={loading}
                variant="outline"
              >
                <RefreshCw className="h-4 w-4" />
              </Button>
            </form>
          </div>
        </CardHeader>
        <CardContent className="pt-6">
          {loading ? (
            <div className="flex flex-col items-center justify-center py-16 space-y-4">
              <Loader2 className="animate-spin text-indigo-600" size={48} />
              <p className="text-gray-500 text-lg">Yükleniyor...</p>
            </div>
          ) : patients.length === 0 ? (
            <div className="flex flex-col items-center justify-center py-16 space-y-4">
              <AlertCircle className="text-gray-400" size={64} />
              <div className="text-center">
                <h3 className="text-xl font-semibold text-gray-700 mb-2">
                  Hasta kaydı bulunamadı
                </h3>
                <p className="text-gray-500">
                  {searchQuery ? `"${searchQuery}" için sonuç bulunamadı` : 'Henüz hasta kaydı yok'}
                </p>
              </div>
            </div>
          ) : (
            <>
              <div className="overflow-x-auto rounded-lg border">
                <table className="min-w-full divide-y divide-gray-200">
                  <thead className="bg-gray-50">
                    <tr>
                      {['Dosya No', 'TC Kimlik', 'Ad Soyad', 'Doğum Tarihi', 'Cinsiyet', 'Telefon', 'Şehir', 'Kan Grubu', 'Durum'].map((header) => (
                        <th key={header} className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                          {header}
                        </th>
                      ))}
                    </tr>
                  </thead>
                  <tbody className="bg-white divide-y divide-gray-200">
                    {patients.map((patient) => (
                      <tr key={patient.patientId} className="hover:bg-indigo-50 transition-colors cursor-pointer">
                        <td className="px-6 py-4 whitespace-nowrap">
                          <span className="text-sm font-mono font-semibold text-indigo-600">
                            {patient.fileNumber}
                          </span>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                          {patient.nationalId}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap">
                          <div className="flex items-center">
                            <div className="flex-shrink-0 h-10 w-10 bg-gradient-to-br from-indigo-500 to-purple-600 rounded-full flex items-center justify-center text-white font-semibold">
                              {patient.name.charAt(0)}{patient.surname.charAt(0)}
                            </div>
                            <div className="ml-3">
                              <div className="text-sm font-semibold text-gray-900">{patient.fullName}</div>
                            </div>
                          </div>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                          {dayjs(patient.birthDate).format('DD/MM/YYYY')}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                          {getGenderLabel(patient.gender)}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                          {patient.phone || '-'}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                          {patient.city || '-'}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap">
                          {patient.bloodType ? (
                            <span className="inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold bg-red-100 text-red-800 border border-red-200">
                              {patient.bloodType}
                            </span>
                          ) : '-'}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap">
                          <span className={`inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold ${
                            patient.active 
                              ? 'bg-green-100 text-green-800 border border-green-200' 
                              : 'bg-gray-100 text-gray-800 border border-gray-200'
                          }`}>
                            {patient.active ? '✓ Aktif' : '✗ Pasif'}
                          </span>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>

              <div className="mt-6 flex items-center justify-between bg-gray-50 px-6 py-4 rounded-lg border">
                <div className="flex items-center space-x-2">
                  <div className="h-2 w-2 bg-green-500 rounded-full animate-pulse"></div>
                  <span className="text-sm font-medium text-gray-700">
                    Toplam {patients.length} hasta | LocalStorage Demo Mode
                  </span>
                </div>
                <Button onClick={loadActivePatients} variant="outline" size="sm">
                  <RefreshCw className="mr-2 h-4 w-4" />
                  Yenile
                </Button>
              </div>
            </>
          )}
        </CardContent>
      </Card>
    </div>
  );
};

export default PatientList;

