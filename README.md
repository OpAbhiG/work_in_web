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
<<<<<<< HEAD
  ✅ Video Consultation
=======
  ✅ Video Consultation  
>>>>>>> 67c0ebdf7e0eebc08d75ec2e95c3c609017e53fc

- **Doctor App**:  
  ✅ Manage Appointments  
  ✅ Specify Availability Slots  
  ✅ View Patient Details  
<<<<<<< HEAD
  ✅ Chat & Video Call Consultations
=======
  ✅ Chat & Video Call Consultations  
>>>>>>> 67c0ebdf7e0eebc08d75ec2e95c3c609017e53fc

- **Admin Portal**:  
  ✅ Manage Users (Doctors, Patients)  
  ✅ Monitor Appointments & Payments  
<<<<<<< HEAD
  ✅ Generate Reports
=======
  ✅ Generate Reports  
>>>>>>> 67c0ebdf7e0eebc08d75ec2e95c3c609017e53fc

- **Super Admin Portal**:  
  ✅ Manage Admins  
  ✅ View System Analytics  
<<<<<<< HEAD
  ✅ Monitor Logs & Security
=======
  ✅ Monitor Logs & Security  
>>>>>>> 67c0ebdf7e0eebc08d75ec2e95c3c609017e53fc

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

<<<<<<< HEAD
- **Patient Portal**: Search Doctors, Book Appointments, View Profile
- **Admin Portal**: Manage Users, Appointments, Generate Reports
- **Super Admin Portal**: Manage Admins, View Analytics
=======
- **Patient Portal**: Search Doctors, Book Appointments, View Profile  
- **Admin Portal**: Manage Users, Appointments, Generate Reports  
- **Super Admin Portal**: Manage Admins, View Analytics  
>>>>>>> 67c0ebdf7e0eebc08d75ec2e95c3c609017e53fc

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
<<<<<<< HEAD
    - `Users`: Patients, Doctors, Admins, Super Admins
    - `Appointments`: Booking details, statuses
    - `MedicalRecords`: Prescriptions, reports
    - `Payments`: Payment history
    - `Logs`: Security logs for monitoring
=======
  - `Users`: Patients, Doctors, Admins, Super Admins  
  - `Appointments`: Booking details, statuses  
  - `MedicalRecords`: Prescriptions, reports  
  - `Payments`: Payment history  
  - `Logs`: Security logs for monitoring  
>>>>>>> 67c0ebdf7e0eebc08d75ec2e95c3c609017e53fc

---

## 🛠️ Technologies Used

### **Frontend**
- **Flutter** (Mobile Apps - Patient & Doctor)
- **React** (Web Apps - Patient, Admin, Super Admin)

### **Backend**
<<<<<<< HEAD
- **Flask (Python)** for API and logic
- **PostgreSQL** as the database for structured data

### **Integration**
- **WebRTC/Socket.io** for real-time communication (Chat/Video)
- **REST APIs** for seamless data handling
=======
- **Flask (Python)** for API and logic  
- **PostgreSQL** as the database for structured data  

### **Integration**
- **WebRTC/Socket.io** for real-time communication (Chat/Video)
- **REST APIs** for seamless data handling  
>>>>>>> 67c0ebdf7e0eebc08d75ec2e95c3c609017e53fc

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

## 📋 Screenshots (Sample)

### Mobile App
<<<<<<< HEAD
- Login & Registration
- Doctor Search
- Appointment Booking

### Web App
- Admin Dashboard
- Appointment Management
=======
- Login & Registration  
- Doctor Search  
- Appointment Booking  

### Web App
- Admin Dashboard  
- Appointment Management  
>>>>>>> 67c0ebdf7e0eebc08d75ec2e95c3c609017e53fc

---

## 📈 Future Enhancements
<<<<<<< HEAD
- Push Notifications for Appointments
- AI-based Doctor Recommendations
=======
- Push Notifications for Appointments  
- AI-based Doctor Recommendations  
>>>>>>> 67c0ebdf7e0eebc08d75ec2e95c3c609017e53fc
- Analytics Dashboard for Admins  
