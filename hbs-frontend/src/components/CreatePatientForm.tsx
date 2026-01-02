import React, { useState } from 'react';
import { useForm } from 'react-hook-form';
import { UserPlus, Check, AlertCircle } from 'lucide-react';
import { patientService } from '../api/patientService';
import { CreatePatientRequest } from '../types/patient';

interface FormData {
  nationalId: string;
  name: string;
  surname: string;
  birthDate: string;
  gender: string;
  phone: string;
  email: string;
  address: string;
  city: string;
  country: string;
  bloodType: string;
  emergencyContact: string;
  emergencyPhone: string;
}

const CreatePatientForm: React.FC = () => {
  const { register, handleSubmit, reset, formState: { errors } } = useForm<FormData>();
  const [loading, setLoading] = useState(false);
  const [successMessage, setSuccessMessage] = useState('');
  const [errorMessage, setErrorMessage] = useState('');

  const onSubmit = async (data: FormData) => {
    setLoading(true);
    setSuccessMessage('');
    setErrorMessage('');

    try {
      const patientData: CreatePatientRequest = {
        ...data,
        country: data.country || 'Türkiye',
      };

      const result = await patientService.createPatient(patientData);
      setSuccessMessage(`Hasta başarıyla kaydedildi! Dosya No: ${result.fileNumber}`);
      reset();
      setTimeout(() => setSuccessMessage(''), 5000);
    } catch (error: any) {
      const errorMsg = error.response?.data?.message || 'Hasta kaydedilirken hata oluştu';
      setErrorMessage(errorMsg);
      setTimeout(() => setErrorMessage(''), 5000);
      console.error('Error creating patient:', error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="max-w-4xl mx-auto">
      <div className="bg-white rounded-lg shadow-md p-6">
        <div className="flex items-center mb-6">
          <UserPlus className="mr-2 text-blue-600" size={24} />
          <h2 className="text-2xl font-bold text-gray-800">Yeni Hasta Kaydı</h2>
        </div>

        {successMessage && (
          <div className="mb-4 p-4 bg-green-50 border border-green-200 rounded-md flex items-center">
            <Check className="mr-2 text-green-600" size={20} />
            <span className="text-green-800">{successMessage}</span>
          </div>
        )}

        {errorMessage && (
          <div className="mb-4 p-4 bg-red-50 border border-red-200 rounded-md flex items-center">
            <AlertCircle className="mr-2 text-red-600" size={20} />
            <span className="text-red-800">{errorMessage}</span>
          </div>
        )}

        <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
          {/* TC Kimlik ve Doğum Tarihi */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                TC Kimlik No <span className="text-red-500">*</span>
              </label>
              <input
                {...register('nationalId', {
                  required: 'TC Kimlik No zorunludur',
                  pattern: {
                    value: /^\d{11}$/,
                    message: 'TC Kimlik No 11 haneli olmalıdır'
                  }
                })}
                type="text"
                maxLength={11}
                placeholder="12345678901"
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
              {errors.nationalId && (
                <p className="mt-1 text-sm text-red-600">{errors.nationalId.message}</p>
              )}
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Doğum Tarihi <span className="text-red-500">*</span>
              </label>
              <input
                {...register('birthDate', { required: 'Doğum tarihi zorunludur' })}
                type="date"
                max={new Date().toISOString().split('T')[0]}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
              {errors.birthDate && (
                <p className="mt-1 text-sm text-red-600">{errors.birthDate.message}</p>
              )}
            </div>
          </div>

          {/* Ad ve Soyad */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Ad <span className="text-red-500">*</span>
              </label>
              <input
                {...register('name', { required: 'Ad zorunludur' })}
                type="text"
                placeholder="Ahmet"
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
              {errors.name && (
                <p className="mt-1 text-sm text-red-600">{errors.name.message}</p>
              )}
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Soyad <span className="text-red-500">*</span>
              </label>
              <input
                {...register('surname', { required: 'Soyad zorunludur' })}
                type="text"
                placeholder="Yılmaz"
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
              {errors.surname && (
                <p className="mt-1 text-sm text-red-600">{errors.surname.message}</p>
              )}
            </div>
          </div>

          {/* Cinsiyet ve Kan Grubu */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Cinsiyet <span className="text-red-500">*</span>
              </label>
              <select
                {...register('gender', { required: 'Cinsiyet zorunludur' })}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <option value="">Cinsiyet seçin</option>
                <option value="MALE">Erkek</option>
                <option value="FEMALE">Kadın</option>
                <option value="OTHER">Diğer</option>
              </select>
              {errors.gender && (
                <p className="mt-1 text-sm text-red-600">{errors.gender.message}</p>
              )}
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Kan Grubu
              </label>
              <select
                {...register('bloodType')}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <option value="">Kan grubu seçin</option>
                <option value="A+">A Rh+</option>
                <option value="A-">A Rh-</option>
                <option value="B+">B Rh+</option>
                <option value="B-">B Rh-</option>
                <option value="AB+">AB Rh+</option>
                <option value="AB-">AB Rh-</option>
                <option value="0+">0 Rh+</option>
                <option value="0-">0 Rh-</option>
              </select>
            </div>
          </div>

          {/* Telefon ve E-posta */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Telefon
              </label>
              <input
                {...register('phone', {
                  pattern: {
                    value: /^(\+90|0)?[0-9]{10}$/,
                    message: 'Geçerli bir telefon numarası girin'
                  }
                })}
                type="tel"
                placeholder="+905551234567"
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
              {errors.phone && (
                <p className="mt-1 text-sm text-red-600">{errors.phone.message}</p>
              )}
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                E-posta
              </label>
              <input
                {...register('email', {
                  pattern: {
                    value: /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i,
                    message: 'Geçerli bir e-posta adresi girin'
                  }
                })}
                type="email"
                placeholder="ornek@email.com"
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
              {errors.email && (
                <p className="mt-1 text-sm text-red-600">{errors.email.message}</p>
              )}
            </div>
          </div>

          {/* Şehir ve Ülke */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div className="space-y-2">
              <Label htmlFor="city">Şehir</Label>
              <Input
                id="city"
                {...register('city')}
                placeholder="İstanbul"
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="country">Ülke</Label>
              <Input
                id="country"
                {...register('country')}
                placeholder="Türkiye"
                defaultValue="Türkiye"
              />
            </div>
          </div>

          {/* Adres */}
          <div className="space-y-2">
            <Label htmlFor="address">Adres</Label>
            <textarea
              id="address"
              {...register('address')}
              rows={3}
              placeholder="Tam adres..."
              className="flex w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 resize-none"
            />
          </div>

          {/* Acil Durum İletişim */}
          <div className="border-t pt-6">
            <h3 className="text-lg font-semibold mb-4 text-gray-700">Acil Durum İletişim Bilgileri</h3>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="space-y-2">
                <Label htmlFor="emergencyContact">Acil Durum Kişisi</Label>
                <Input
                  id="emergencyContact"
                  {...register('emergencyContact')}
                  placeholder="İsim Soyisim"
                />
              </div>

              <div className="space-y-2">
                <Label htmlFor="emergencyPhone">Acil Durum Telefon</Label>
                <Input
                  id="emergencyPhone"
                  type="tel"
                  {...register('emergencyPhone')}
                  placeholder="+905551234567"
                />
              </div>
            </div>
          </div>

          <Button
            type="submit"
            disabled={loading}
            size="lg"
            className="w-full text-lg h-12 mt-2"
          >
            {loading ? (
              <>
                <Loader2 className="mr-2 h-5 w-5 animate-spin" />
                Kaydediliyor...
              </>
            ) : (
              <>
                <UserPlus className="mr-2 h-5 w-5" />
                Hasta Kaydı Oluştur
              </>
            )}
          </Button>
        </form>
        </CardContent>
      </Card>
    </div>
  );
};

export default CreatePatientForm;
  );
};

export default CreatePatientForm;

