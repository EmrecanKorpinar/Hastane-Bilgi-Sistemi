import React, { useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, Link, useLocation } from 'react-router-dom';
import { Home, UserPlus, Users, Activity } from 'lucide-react';
import { Toaster } from './components/toaster';
import CreatePatientForm from './components/CreatePatientForm';
import PatientList from './components/PatientList';
import { initializeDemoData } from './api/mockPatientService';
import './App.css';

const Navigation: React.FC = () => {
  const location = useLocation();

  const isActive = (path: string) => location.pathname === path;

  const navItems = [
    { path: '/', label: 'Ana Sayfa', icon: Home },
    { path: '/create-patient', label: 'Yeni Hasta', icon: UserPlus },
    { path: '/patients', label: 'Hasta Listesi', icon: Users },
  ];

  return (
    <nav className="bg-gradient-to-r from-blue-600 to-blue-700 text-white shadow-lg">
      <div className="container mx-auto px-4">
        <div className="flex items-center justify-between h-16">
          <div className="flex items-center space-x-8">
            <div className="flex items-center space-x-2">
              <Activity className="h-8 w-8" />
              <h1 className="text-xl font-bold">HBS - Hastane Bilgi Sistemi</h1>
            </div>
            <div className="flex space-x-1">
              {navItems.map(({ path, label, icon: Icon }) => (
                <Link
                  key={path}
                  to={path}
                  className={`flex items-center space-x-2 px-4 py-2 rounded-md transition-all ${
                    isActive(path) 
                      ? 'bg-white/20 backdrop-blur-sm' 
                      : 'hover:bg-white/10'
                  }`}
                >
                  <Icon size={18} />
                  <span>{label}</span>
                </Link>
              ))}
            </div>
          </div>
          <div className="flex items-center space-x-2 text-sm bg-white/10 px-3 py-1 rounded-full">
            <div className="h-2 w-2 bg-green-400 rounded-full animate-pulse"></div>
            <span>Demo Mode (LocalStorage)</span>
          </div>
        </div>
      </div>
    </nav>
  );
};

const HomePage: React.FC = () => {
  return (
    <div className="text-center py-16 space-y-8">
      <div className="space-y-4">
        <h2 className="text-5xl font-bold text-gray-800">Hoş Geldiniz</h2>
        <p className="text-xl text-gray-600 max-w-3xl mx-auto">
          HBS - Hastane Bilgi Sistemi'ne hoş geldiniz.
          Bu sistem mikroservis mimarisi, event-driven tasarım ve modern güvenlik yaklaşımları ile geliştirilmiştir.
        </p>
      </div>

      <div className="bg-gradient-to-r from-yellow-50 to-orange-50 border-2 border-yellow-200 rounded-xl p-8 max-w-4xl mx-auto shadow-lg">
        <div className="flex items-start space-x-4">
          <div className="flex-shrink-0">
            <div className="h-12 w-12 bg-yellow-400 rounded-full flex items-center justify-center">
              <span className="text-2xl">⚡</span>
            </div>
          </div>
          <div className="flex-1 text-left">
            <h3 className="text-2xl font-bold text-yellow-900 mb-2">Demo Modu Aktif</h3>
            <p className="text-yellow-800 text-lg leading-relaxed">
              Docker ve Maven kurulu olmadığı için <strong>mock backend</strong> kullanıyorsunuz.
              Tüm veriler tarayıcınızın <code className="bg-yellow-200 px-2 py-1 rounded">localStorage</code> alanında saklanıyor.
              Gerçek backend için IntelliJ IDEA ile servisleri başlatın.
            </p>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-6xl mx-auto pt-8">
        <div className="group bg-white p-8 rounded-xl shadow-md hover:shadow-2xl transition-all duration-300 border-2 border-transparent hover:border-blue-200">
          <div className="text-6xl mb-4 group-hover:scale-110 transition-transform">🔧</div>
          <h3 className="text-2xl font-bold mb-3 text-gray-800">Microservices</h3>
          <p className="text-gray-600 leading-relaxed">Bağımsız ölçeklenebilir servisler ile modüler mimari</p>
        </div>
        <div className="group bg-white p-8 rounded-xl shadow-md hover:shadow-2xl transition-all duration-300 border-2 border-transparent hover:border-green-200">
          <div className="text-6xl mb-4 group-hover:scale-110 transition-transform">⚡</div>
          <h3 className="text-2xl font-bold mb-3 text-gray-800">Event-Driven</h3>
          <p className="text-gray-600 leading-relaxed">Kafka ile asenkron iletişim ve gerçek zamanlı veri akışı</p>
        </div>
        <div className="group bg-white p-8 rounded-xl shadow-md hover:shadow-2xl transition-all duration-300 border-2 border-transparent hover:border-purple-200">
          <div className="text-6xl mb-4 group-hover:scale-110 transition-transform">🔒</div>
          <h3 className="text-2xl font-bold mb-3 text-gray-800">Zero Trust</h3>
          <p className="text-gray-600 leading-relaxed">Güvenli, denetlenebilir ve şifrelenmiş iletişim</p>
        </div>
      </div>

      <div className="pt-8 space-y-4">
        <h3 className="text-2xl font-semibold text-gray-700">Teknoloji Stack</h3>
        <div className="flex flex-wrap justify-center gap-3">
          {['React 18', 'TypeScript', 'Tailwind CSS', 'shadcn/ui', 'Spring Boot', 'PostgreSQL', 'Kafka', 'Docker'].map((tech) => (
            <span key={tech} className="px-4 py-2 bg-blue-100 text-blue-700 rounded-full font-medium">
              {tech}
            </span>
          ))}
        </div>
      </div>
    </div>
  );
};

const App: React.FC = () => {
  useEffect(() => {
    // Demo data'yı initialize et
    initializeDemoData();
  }, []);

  return (
    <Router>
      <div className="min-h-screen bg-gradient-to-br from-gray-50 to-blue-50 flex flex-col">
        <Navigation />

        <main className="flex-1 container mx-auto px-4 py-8">
          <Routes>
            <Route path="/" element={<HomePage />} />
            <Route path="/create-patient" element={<CreatePatientForm />} />
            <Route path="/patients" element={<PatientList />} />
          </Routes>
        </main>

        <footer className="bg-white border-t border-gray-200 py-6 shadow-inner">
          <div className="container mx-auto px-4 text-center">
            <p className="text-gray-600">
              HBS - Hastane Bilgi Sistemi ©2026 |
              <span className="font-semibold text-blue-600"> Microservices Architecture</span> |
              <span className="text-sm"> powered by shadcn/ui + Tailwind CSS</span>
            </p>
          </div>
        </footer>

        <Toaster />
      </div>
    </Router>
  );
};

export default App;

