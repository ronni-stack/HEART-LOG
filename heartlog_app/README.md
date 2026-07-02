# HeartLog Flutter App

**Your heart. Your voice. Your peace.**

A full Flutter mobile app based on the HeartLog design: a calm, voice-first journaling and meditation companion.

## Features

- 🏠 **Home** – Daily mood check-in and one-tap voice recording
- 🎙️ **Voice Recording** – Records audio with live speech-to-text transcription
- 📝 **Journal Entry** – Review, edit, and save your voice/text entries
- 📔 **My Journal** – Searchable history of all entries with mood indicators
- 🧘 **Calm / Meditate** – Guided meditation and breathing cards
- 👤 **Profile** – Settings and account overview

## Tech Stack

- **Flutter** 3.22.2
- **Dart** 3.4.3
- Packages:
  - `record` – microphone recording
  - `audioplayers` – audio playback
  - `speech_to_text` – live transcription
  - `sqflite` – local SQLite journal storage
  - `path_provider` / `path` – file paths
  - `intl` – date formatting
  - `google_fonts` – Playfair Display + Nunito typography
  - `uuid` – unique entry IDs
  - `provider` – state management (ready for future use)

## Project Structure

```
lib/
├── main.dart                 # App entry + bottom navigation
├── models/
│   ├── journal_entry.dart    # Journal data model
│   └── meditation.dart       # Meditation data + sample list
├── services/
│   ├── audio_service.dart    # Recording / playback logic
│   └── database_service.dart # SQLite CRUD for entries
├── screens/
│   ├── home_screen.dart
│   ├── recording_screen.dart
│   ├── entry_detail_screen.dart
│   ├── journal_screen.dart
│   ├── meditate_screen.dart
│   └── profile_screen.dart
├── theme/
│   ├── app_colors.dart       # HeartLog color palette
│   └── app_theme.dart        # Typography & component themes
└── widgets/
    └── bottom_nav.dart       # Custom bottom navigation
```

## Build APK with GitHub Actions

A workflow is included at `.github/workflows/build_apk.yml`. It automatically builds a release APK on every push to `main` or `master`.

To use it:

1. Push this project to a GitHub repository
2. Go to the **Actions** tab in your repo
3. Click the **Build HeartLog Android APK** workflow
4. Select **Run workflow** (or wait for the next push)
5. When the build finishes, download the `heartlog-apk` artifact
6. Transfer `app-release.apk` to your Android phone and install it

## Run the App

Make sure Flutter is installed and on your PATH, then:

```bash
cd heartlog_app
flutter pub get
flutter run
```

### Android

```bash
flutter build apk --release
```

### iOS

```bash
cd ios
pod install
cd ..
flutter build ios --release
```

> Note: iOS builds require macOS + Xcode. Android builds require the Android SDK.

## Permissions

- **Android** – `RECORD_AUDIO` is declared in `AndroidManifest.xml`
- **iOS** – `NSMicrophoneUsageDescription` and `NSSpeechRecognitionUsageDescription` are declared in `Info.plist`

## Design

Color palette and screens are based on the HeartLog brand board:

| Color     | Hex     |
|-----------|---------|
| Sage      | #A8C5B5 |
| Cream     | #F7E6D6 |
| Peach     | #FFD6B8 |
| Teal      | #7BA3A1 |
| Dark Green| #4E6B63 |

## Next Steps

- Connect to **Firebase** for cloud backup & authentication
- Add real meditation audio assets
- Implement push notifications for daily journaling reminders
- Add mood analytics / insights
