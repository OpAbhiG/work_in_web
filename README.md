# work_in_web

# Doctor Appointment Booking App

This is a Flutter-based app for booking doctor appointments, including features for patients and doctors. The app allows users to register, log in, manage appointments, and more.

---
![flowchartBharatApp.webp](..%2F..%2F..%2FBharatTeliClinicMaterial%2FBharatTeleClinicLogo%2FflowchartBharatApp.webp)

## Project File Structure

The following flowchart explains the structure of the project:

```plaintext
main.dart
  |
  ├── app.dart                     // Application entry point and routes
  |
  ├── screens/
  │   ├── authentication/          // User authentication screens
  │   │   ├── login_screen.dart       // Login screen for users
  │   │   └── registration_screen.dart // Registration screen for users
  │   ├── profile/                 // User profile management screens
  │   │   ├── profile_screen.dart     // User profile display
  │   │   └── edit_profile_screen.dart // Edit user profile details
  │   ├── appointments/            // Appointment-related screens
  │   │   ├── appointments_nav_screen.dart // Appointment navigation screen
  │   │   ├── book_appointment_dialog_status.dart // Appointment booking dialog
  │   │   ├── booking_screen.dart    // Appointment booking screen
  │   │   └── booking_confirmation_screen.dart // Booking confirmation screen
  │   ├── medical/                 // Medical records and history
  │   │   ├── medical_record_screen.dart // User medical records
  │   │   └── medical_history_screen.dart // User medical history
  │   ├── dashboard/               // Dashboard and language settings
  │   │   ├── dashboard_screen.dart   // Main dashboard
  │   │   └── language_clinic_selection_screen.dart // Language and clinic selection
  │   ├── doctor/                  // Doctor-related screens
  │   │   ├── doctor_detail_screen.dart  // Doctor's profile and details
  │   │   ├── doctor_nav_screen.dart     // Doctor navigation screen
  │   │   └── drugs_tests_screen.dart    // Drugs and lab tests section
  │   ├── others/                  // Miscellaneous screens
  │       ├── splash_screen.dart      // Splash screen at app launch
  │       ├── payment_screen.dart     // Payment integration screen
  │       ├── video_call_screen.dart  // Video call consultation screen
  │       └── confirmation_screen.dart // General confirmation screen
  |
  ├── widgets/                     // Reusable UI components
  │   ├── custom_button.dart          // Custom button widget
  │   └── custom_text_field.dart      // Custom text field widget
  |
  ├── models/                      // Data models for the app
  │   ├── user_model.dart             // User data structure
  │   └── appointment_model.dart      // Appointment data structure
  |
  ├── services/                    // API and service integrations
  │   ├── api_service.dart           // API base and endpoints
  │   └── auth_service.dart          // Authentication service
  |
  ├── utils/                       // Utilities and constants
  │   ├── constants.dart             // App-wide constants
  │   ├── app_theme.dart             // Theme configurations
  │   └── helpers.dart               // Helper functions
  |
  └── providers/ (Optional)        // State management files
      ├── auth_provider.dart         // Authentication state management
      └── appointment_provider.dart  // Appointment state management

---

## Features
- User Authentication (Login, Registration)
- Book Appointments
- Manage Medical Records and History
- View and Edit User Profile
- Payment Integration
- Video Call Consultations
- Multi-language Support

---

## Setup Instructions
1. Clone this repository.
2. Run `flutter pub get` to install dependencies.
3. Use the `main.dart` file as the entry point to run the app.
4. Ensure the API services are correctly configured in the `services/` folder.

---

## Flowchart
```plaintext
[main.dart]
    |
    --> [app.dart]
        |
        --> [screens/]
            |
            --> authentication/
            |      ├── login_screen.dart
            |      └── registration_screen.dart
            |
            --> profile/
            |      ├── profile_screen.dart
            |      └── edit_profile_screen.dart
            |
            --> appointments/
            |      ├── appointments_nav_screen.dart
            |      ├── book_appointment_dialog_status.dart
            |      ├── booking_screen.dart
            |      └── booking_confirmation_screen.dart
            |
            --> medical/
            |      ├── medical_record_screen.dart
            |      └── medical_history_screen.dart
            |
            --> dashboard/
            |      ├── dashboard_screen.dart
            |      └── language_clinic_selection_screen.dart
            |
            --> doctor/
            |      ├── doctor_detail_screen.dart
            |      ├── doctor_nav_screen.dart
            |      └── drugs_tests_screen.dart
            |
            --> others/
                   ├── splash_screen.dart
                   ├── payment_screen.dart
                   ├── video_call_screen.dart
                   └── confirmation_screen.dart
