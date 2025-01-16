work in web

---


flutter run -d chrome --web-renderer html // to run the app

## 🗂️ Project File Structure

lib/
├── api/
│   ├── api_service.dart            # API communication logic (base URL setup, requests)
│   ├── auth_api.dart              # Login and Registration API integration
│   ├── doctor_api.dart            # Doctor-related API calls (filter, fetch doctor list)
│   └── appointment_api.dart       # Appointment booking API calls
├── models/
│   ├── login_model.dart           # Login response model
│   ├── doctor_model.dart          # Doctor data model
│   ├── appointment_model.dart     # Appointment data model
│   └── user_model.dart            # User data model for registration
├── screens/
│   ├── login_screen.dart          # Login screen UI
│   ├── registration_screen.dart   # Registration screen UI
│   ├── dashboard_screen.dart      # Patient and Doctor dashboard screens
│   ├── doctor_profile_screen.dart # Doctor profile screen
│   ├── appointment_screen.dart    # Appointment booking screen for patients
│   ├── doctor_appointment_screen.dart  # Appointment management for doctors
│   └── treatment_screen.dart      # Treatment/Consultation screen
├── widgets/
│   ├── custom_button.dart         # Custom reusable button widget
│   ├── doctor_card.dart           # Doctor card widget
│   ├── profile_card.dart          # Profile card widget
│   └── appointment_tile.dart      # Appointment tile for list view
├── services/
│   ├── video_call_service.dart    # Logic for handling video calls with ZEGOCLOUD SDK
│   └── notification_service.dart  # Logic for handling notifications
├── utils/
│   ├── constants.dart             # App constants (URLs, keys, etc.)
│   └── validators.dart            # Input validators (email, password)
├── theme/
│   └── app_theme.dart             # App theme setup (colors, text styles)
├── main.dart                      # App entry point (MaterialApp, routing)
└── routes.dart                    # Routing and navigation logic (named routes)
