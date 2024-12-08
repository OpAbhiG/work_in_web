# work_in_web

# Doctor Appointment Booking App

This is a Flutter-based app for booking doctor appointments, including features for patients and doctors. The app allows users to register, log in, manage appointments, and more.

---
## Project File Structure

The following flowchart explains the structure of the project:

```plaintext

[main.dart] 
   |
   └── [app.dart]                   // Application entry point and routes
        |
        └── [screens/]              // Folder containing screen files
             ├── [authentication/]  
             │     ├── login_screen.dart          // Login screen for users
             │     └── registration_screen.dart   // Registration screen for users
             │
             ├── [profile/]                      
             │     ├── profile_screen.dart        // User profile display screen
             │     └── edit_profile_screen.dart   // Edit user profile details
             │
             ├── [appointments/]                 
             │     ├── appointments_nav_screen.dart      // Navigation for appointments
             │     ├── book_appointment_dialog_status.dart // Appointment booking dialog
             │     ├── booking_screen.dart               // Appointment booking screen
             │     └── booking_confirmation_screen.dart  // Booking confirmation screen
             │
             ├── [medical/]                     
             │     ├── medical_record_screen.dart  // Medical records display
             │     └── medical_history_screen.dart // Medical history screen
             │
             ├── [dashboard/]                 
             │     ├── dashboard_screen.dart             // Main dashboard
             │     └── language_clinic_selection_screen.dart // Language and clinic selection
             │
             ├── [doctor/]                     
             │     ├── doctor_detail_screen.dart   // Doctor's profile and details
             │     ├── doctor_nav_screen.dart      // Navigation for doctor-related screens
             │     └── drugs_tests_screen.dart     // Drugs and lab test information
             │
             ├── [others/]                        
                   ├── splash_screen.dart          // Splash screen at app startup
                   ├── payment_screen.dart         // Payment screen for appointments
                   ├── video_call_screen.dart      // Video consultation screen
                   └── confirmation_screen.dart    // General confirmation screen

        ├── [widgets/]                    
        │     ├── custom_button.dart            // Reusable custom button widget
        │     └── custom_text_field.dart        // Reusable custom text field widget

        ├── [models/]                    
        │     ├── user_model.dart              // Data model for user information
        │     └── appointment_model.dart       // Data model for appointments

        ├── [services/]                  
        │     ├── api_service.dart            // API base and endpoint integrations
        │     └── auth_service.dart           // Authentication-related services

        ├── [utils/]                    
        │     ├── constants.dart              // App-wide constants
        │     ├── app_theme.dart              // Theme configurations
        │     └── helpers.dart                // Utility/helper functions

        ├── [providers/] (Optional)            
              ├── auth_provider.dart           // State management for authentication
              └── appointment_provider.dart    // State management for appointments

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
