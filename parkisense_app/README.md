# ParkiSense — Flutter Mobile App

This is the Android mobile frontend for ParkiSense. It records a voice sample, extracts acoustic features, sends them to the FastAPI backend, and displays a Parkinson's disease screening result.

---

## Setup

### Prerequisites

- Flutter SDK 3.0 or higher
- Android Studio with an emulator (Pixel 6, API 33 recommended)
- A running instance of the ParkiSense backend

### Steps

```bash
# Navigate to the app directory
cd mobile/parkisense_app

# Install dependencies
flutter pub get

# Run on emulator
flutter run
```

---

## Backend URL

The app points to the live backend by default. To change it, open `lib/constants.dart` and update:

```dart
static const String baseUrl = 'https://parkisense-backend.onrender.com';
```

---

## App Screens

| Screen | Description |
|--------|-------------|
| Home | Introduction, disclaimer, and start button |
| Record | Microphone recording with live status indicator |
| Result | Prediction result, confidence score, and features analysed |

---

## Tech Stack

- Flutter (Dart)
- flutter_sound — audio recording
- http — API communication
- path_provider — file storage
- permission_handler — microphone permission