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
- Add your Android/iOS apps
- Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
- Place them in the respective directories

4. Configure environment
```bash
cp .env.example .env
# Edit .env with your Firebase project ID
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
└── app.dart       # App itself
└── main.dart      # Entry point
```

## Development Status

**Phase 1: Foundation** ✅ Complete
- Project setup and dependencies
- Theme system and constants
- Core widgets and navigation

**Phase 2: Auth Flow** 🔄 In Progress
- Splash screen, biometric gate, login
- Firebase Auth integration

**Phase 3: Face Verification** 🔄 In Progress
- Camera integration
- ML Kit face detection

**Phase 4: Main App** 🔄 In Progress
- Bottom navigation, home, voting, results

**Phase 5-6: Polish & Deployment** 📅 Planned

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

Project Link: [https://github.com/retzonel/votrr_app](https://github.com/retzonel/votrr_app)
