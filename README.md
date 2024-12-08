work in web
---

# 🏥 Doctor Appointment Booking System

This is a **Doctor Appointment Booking App** developed using **Flutter, React, Flask, and PostgreSQL**, designed for Patients, Doctors, Admins, and Super Admins. The system offers seamless appointment management, user-friendly interfaces, and robust backend support for both mobile and web platforms.

---

## 🚀 Features

- **Patient App**:  
  ✅ Login & Registration  
  ✅ Search and Filter Doctors  
  ✅ Book & Manage Appointments  
  ✅ Payment Integration  
  ✅ Medical Records & History  
  ✅ Video Consultation  

- **Doctor App**:  
  ✅ Manage Appointments  
  ✅ Specify Availability Slots  
  ✅ View Patient Details  
  ✅ Chat & Video Call Consultations  

- **Admin Portal**:  
  ✅ Manage Users (Doctors, Patients)  
  ✅ Monitor Appointments & Payments  
  ✅ Generate Reports  

- **Super Admin Portal**:  
  ✅ Manage Admins  
  ✅ View System Analytics  
  ✅ Monitor Logs & Security  

---

## 🗂️ Project File Structure

### **Frontend - Flutter (Mobile Apps)**

```plaintext
[main.dart]
   |
   └── [app.dart] // App entry point & route management
        ├── [screens/]
        │     ├── authentication/   (Login, Registration)
        │     ├── profile/          (View & Edit Profile)
        │     ├── appointments/     (Manage Appointments)
        │     ├── medical/          (Medical Records & History)
        │     ├── dashboard/        (Dashboard & Clinic Selection)
        │     ├── doctor/           (Doctor Details, Tests)
        │     ├── others/           (Splash, Payments, Video Call)
        ├── [widgets/]              (Reusable Components)
        ├── [models/]               (Data Models)
        ├── [services/]             (API Services)
        ├── [utils/]                (Helpers, Constants)
        └── [providers/]            (State Management)
```

### **Frontend - React (Web App)**

- **Patient Portal**: Search Doctors, Book Appointments, View Profile  
- **Admin Portal**: Manage Users, Appointments, Generate Reports  
- **Super Admin Portal**: Manage Admins, View Analytics  

### **Backend - Flask (Python)**

```plaintext
[Backend Root]
   ├── [app.py]                   // Main Flask app
   ├── [routes/]                  // API endpoints
   │     ├── auth_routes.py       // User authentication APIs
   │     ├── appointment_routes.py// Appointment-related APIs
   │     ├── doctor_routes.py     // Doctor-related APIs
   │     ├── payment_routes.py    // Payment integration APIs
   │     └── reporting_routes.py  // Admin reports & analytics
   ├── [models/]                  // Database models (SQLAlchemy)
   ├── [services/]                // Helper services (JWT, Mail, etc.)
   ├── [utils/]                   // Utility functions
   └── [config.py]                // Application configurations
```

### **Database - PostgreSQL**

- **Tables**:
  - `Users`: Patients, Doctors, Admins, Super Admins  
  - `Appointments`: Booking details, statuses  
  - `MedicalRecords`: Prescriptions, reports  
  - `Payments`: Payment history  
  - `Logs`: Security logs for monitoring  

---

## 🛠️ Technologies Used

### **Frontend**
- **Flutter** (Mobile Apps - Patient & Doctor)
- **React** (Web Apps - Patient, Admin, Super Admin)

### **Backend**
- **Flask (Python)** for API and logic  
- **PostgreSQL** as the database for structured data  

### **Integration**
- **WebRTC/Socket.io** for real-time communication (Chat/Video)
- **REST APIs** for seamless data handling  

---

## 🎯 System Architecture

```plaintext
[System Overview]
   |
   ├── Frontend:
   │     ├── Flutter (Mobile: Patient & Doctor Apps)
   │     ├── React (Web: Patient, Admin, Super Admin Portals)
   |
   ├── Backend:
   │     ├── Flask (APIs, Business Logic)
   │     └── PostgreSQL (Database)
   |
   ├── Integration:
   │     ├── REST APIs for all platforms
   │     └── Real-time Communication via WebRTC
   |
   └── User Roles:
         - Patients, Doctors, Admins, Super Admins
```

---

## 🌟 App Flow

```plaintext
1. User opens the app (Flutter/React).
2. User logs in or registers (API: Flask).
3. Patient:
   - Searches for doctors (Filtered by specialty).
   - Books an appointment (API).
   - Makes a payment (Payment Gateway).
   - Views appointment and medical history.
   - Consults doctor via video call (WebRTC).
4. Doctor:
   - Manages availability slots.
   - Views patient details and appointments.
   - Interacts with patients (Chat/Video).
5. Admin/Super Admin:
   - Manages users and appointments.
   - Monitors system performance and logs.
   - Generates reports and analytics.
```

---

## 🔧 How to Run the Project

### 1. **Backend (Flask)**
```bash
cd backend
python app.py
```

### 2. **Mobile Frontend (Flutter)**
```bash
cd flutter-app
flutter run
```

### 3. **Web Frontend (React)**
```bash
cd web-app
npm start
```

---

## 📋 Screenshots (Sample)

### Mobile App
- Login & Registration  
- Doctor Search  
- Appointment Booking  

### Web App
- Admin Dashboard  
- Appointment Management  

---

## 📈 Future Enhancements
- Push Notifications for Appointments  
- AI-based Doctor Recommendations  
- Analytics Dashboard for Admins  
