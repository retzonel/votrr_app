# Votrr

A biometric-enabled voting application prototype built with Flutter.

## Overview

Votrr is a mobile voting application prototype that demonstrates secure voter authentication using device biometrics and facial recognition. Built with Flutter and Firebase, it showcases modern mobile security patterns in a government-tech context.

## Features

- **Biometric Authentication** - Fingerprint, Face Unlock, PIN, and Pattern support
- **Face Verification** - On-device facial recognition using Google ML Kit
- **Secure Voting** - Multi-factor authentication before voting
- **Live Results** - Real-time vote counting with charts
- **Election Dashboard** - Countdown timers and election status

## Tech Stack

- Flutter 3.5+
- Firebase (Auth, Firestore, Storage)
- Riverpod for state management
- Google ML Kit for face detection
- Local Authentication for device biometrics

## Getting Started

### Prerequisites

- Flutter SDK 3.5.0 or higher
- Android Studio / VS Code
- Firebase account
- Android device (API 21+) or iOS device (12.0+)

### Installation

1. Clone the repository
```bash
git clone https://github.com/retzonel/votrr_app.git
cd votrr
```

2. Install dependencies
```bash
flutter pub get
```

3. Set up Firebase
- Create a Firebase project
- Add your Android apps
- Download `google-services.json` (Android)
- Place them in the respective directories

4. Configure environment
```bash
cp .env.example .env
# Edit .env with your Firebase project ID
flutterfire configure
# Generate firebase_options.dart
```

5. Run the app
```bash
flutter run
```

## Project Structure

```
lib/
├── core/          # Shared infrastructure (theme, constants, navigation)
├── features/      # Feature-first modules
│   ├── auth/      # Authentication
│   ├── feed/      # Live feed
│   ├── polling/   # General information on elections
│   ├── shell/     # Main app navigation
│   └── settings/  # Settings and user
│   ├── vote/      # Voting functionality
└── app.dart       # the App itself
└── main.dart      # Entry point
```

## Development Status

**Phase 1: Foundation** ✅ Complete
- Project setup and dependencies
- Theme system and constants
- Core widgets and navigation

**Phase 2: Auth Flow** ✅ Complete
- Splash screen, biometric gate, login
- Firebase Auth integration
<img width="720" height="1600" alt="Screenshot_20260626-025513" src="https://github.com/user-attachments/assets/c1275d8f-bef1-4d80-b85e-cd8b29e4b0fd" />
<img width="720" height="1600" alt="Screenshot_20260626-025619" src="https://github.com/user-attachments/assets/2b83def1-6e74-4e4b-b25e-ca63a5dc2832" />
<img width="720" height="1600" alt="Screenshot_20260626-025622" src="https://github.com/user-attachments/assets/9de47abd-dea9-4b7f-a116-d5479cff9cfb" />

**Phase 3: Face Verification** ✅ Complete
- Camera integration
- ML Kit face detection

**Phase 4: Main App** ✅ Complete
- Bottom navigation, home, voting, results
<img width="720" height="1600" alt="Screenshot_20260626-025609" src="https://github.com/user-attachments/assets/1f520d54-ac47-46b0-9c05-5636fbc526b4" />

**Phase 5-6: Polish & Deployment** ✅ Complete

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

Null

## Contact

Nwocha Godswill - [@retzonel](https://twitter.com/retzonel) - nwochagodswill@gmail.com
