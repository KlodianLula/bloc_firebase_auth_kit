# bloc_firebase_auth_kit Example

A minimal example demonstrating how to use the `bloc_firebase_auth_kit` package.

## Setup Instructions

### 1. Configure Firebase

Before running this example, you need to set up Firebase for your platform:

#### Install FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```

#### Configure Firebase
```bash
cd example
flutterfire configure
```

This will:
- Create a Firebase project (or select an existing one)
- Register your app for all platforms
- Generate `firebase_options.dart` with your configuration

### 2. Add Firebase Configuration Files

#### Android
1. Download `google-services.json` from Firebase Console
2. Place it in `android/app/`

#### iOS
1. Download `GoogleService-Info.plist` from Firebase Console
2. Add it to `ios/Runner/` in Xcode

#### Web
1. The configuration is already in `firebase_options.dart`
2. For Google Sign-In, add this to `web/index.html`:
```html
<head>
  <meta name="google-signin-client_id" content="YOUR_WEB_CLIENT_ID.apps.googleusercontent.com">
</head>
```

### 3. Enable Authentication Providers

In the [Firebase Console](https://console.firebase.google.com):
1. Go to Authentication > Sign-in method
2. Enable the providers you want to use:
   - Email/Password
   - Google
   - Facebook (optional)

### 4. Platform-Specific Setup

#### Android - Google Sign-In
Add your SHA-1 fingerprint to Firebase Console:
```bash
cd android
./gradlew signingReport
```

#### iOS - Google Sign-In
Add the URL scheme to `ios/Runner/Info.plist`:
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>YOUR_REVERSED_CLIENT_ID</string>
    </array>
  </dict>
</array>
```

Find `REVERSED_CLIENT_ID` in your `GoogleService-Info.plist`.

### 5. Update main.dart

Uncomment the Firebase initialization in `lib/main.dart`:
```dart
import 'firebase_options.dart';

// Uncomment these lines:
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

For web with Google Sign-In, also add your client ID:
```dart
await AuthServiceLocator.init(
  googleClientId: kIsWeb ? 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com' : null,
);
```

### 6. Run the Example

```bash
flutter pub get
flutter run
```

For web (recommended to use port 5000):
```bash
flutter run -d chrome --web-port 5000
```

## Features Demonstrated

This example demonstrates:
- ✅ Email/Password authentication
- ✅ Google Sign-In
- ✅ Facebook Sign-In
- ✅ Pre-built sign-in form
- ✅ Social sign-in buttons
- ✅ Auth state management with BLoC
- ✅ Persistent authentication
- ✅ Sign out functionality

## Code Overview

The example uses the `AuthWrapper` widget which automatically handles navigation based on authentication state:

```dart
AuthWrapper(
  signedInBuilder: (context, user) => HomePage(user: user),
  signedOutBuilder: (context) => LoginPage(),
)
```

The `AuthBloc` manages authentication state and is initialized with all use cases from the package.

## Troubleshooting

### Firebase Not Initialized
Make sure you've run `flutterfire configure` and uncommented the Firebase initialization code.

### Google Sign-In Issues
- **Web**: Ensure the client ID meta tag is in `index.html`
- **Android**: Add SHA-1 fingerprint to Firebase Console
- **iOS**: Add REVERSED_CLIENT_ID to URL schemes

### Package Not Found
Make sure you're in the example directory and have run `flutter pub get`.

## Learn More

For more advanced usage and configuration options, see the main package README at the root of this repository.

