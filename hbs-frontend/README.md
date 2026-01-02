# HBS Frontend - React TypeScript

Modern React + TypeScript frontend for Hospital Information System (HBS)

## 🚀 Tech Stack
- React 18
- TypeScript
- Axios (HTTP client)
- React Router (navigation)
- Ant Design (UI components)
- React Query (data fetching)
- Tailwind CSS (styling)

## 📁 Project Structure
```
hbs-frontend/
├── src/
│   ├── api/              # API client & services
│   ├── components/       # Reusable components
│   ├── pages/           # Page components
│   ├── types/           # TypeScript types
│   ├── utils/           # Utility functions
│   ├── App.tsx
│   └── index.tsx
├── public/
└── package.json
```

## 🛠️ Development

### Install Dependencies
```bash
cd hbs-frontend
npm install
```

### Start Development Server
```bash
npm start
```

Frontend will run on: **http://localhost:3001**

### Build for Production
```bash
npm run build
```

## 📡 API Integration

Base URL: `http://localhost:8000` (API Gateway)

### Endpoints
- `POST /api/patient` - Create patient
- `GET /api/patient/{id}` - Get patient by ID
- `GET /api/patient/national-id/{nationalId}` - Get by national ID
- `GET /api/patient/search?query={query}` - Search patients

## 🎨 Features

### Patient Management
- ✅ Create new patient
- ✅ View patient details
- ✅ Search patients by name
- ✅ List all active patients
- ✅ Form validation
- ✅ Error handling
- ✅ Loading states

### Dashboard
- Patient statistics
- Recent registrations
- Quick actions

## 🔧 Configuration

Create `.env` file:
```
REACT_APP_API_URL=http://localhost:8000
```

## 📦 Dependencies

```json
{
  "dependencies": {
    "react": "^18.2.0",
    "react-router-dom": "^6.20.0",
    "axios": "^1.6.2",
    "@tanstack/react-query": "^5.14.0",
    "antd": "^5.12.0",
    "dayjs": "^1.11.10"
  }
}
```

