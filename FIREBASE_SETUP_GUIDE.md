# FIREBASE SETUP GUIDE

## 1. Create Firebase Project

1. Go to https://console.firebase.google.com
2. Click **Add Project**
3. Enter project name: **CurrenSee**
4. Disable Google Analytics (optional)
5. Create project

---

## 2. Add Firebase to Flutter

Run in your project folder:

```bash
# Install Firebase CLI if not already installed
npm install -g firebase-tools

# Login to Firebase
firebase login

# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your Flutter project
flutterfire configure
```

This will generate:
- `firebase_options.dart`
- Update your Firebase project with Flutter app configurations

---

## 3. Add Firebase SDK

The required dependencies are already in `pubspec.yaml`:

```yaml
firebase_core: ^2.25.0
firebase_auth: ^4.16.0
cloud_firestore: ^4.14.0
firebase_messaging: ^14.7.10
google_sign_in: ^6.2.1
```

Run:

```bash
flutter pub get
```

---

## 4. Android Setup

### 4.1 Get SHA-1 & SHA-256 Fingerprints

Run this command to get your debug keystore fingerprints:

```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

Copy the **SHA-1** and **SHA-256** values.

### 4.2 Add Fingerprints to Firebase

1. Go to Firebase Console → Project Settings
2. Select your Android app
3. Scroll to **SHA certificate fingerprints**
4. Click **Add fingerprint**
5. Paste SHA-1 and SHA-256

### 4.3 Download google-services.json

1. In Firebase Console, download `google-services.json`
2. Place it in: `android/app/google-services.json`

### 4.4 Update Android Configuration

**File: `android/build.gradle`**

Add Google services classpath:

```gradle
buildscript {
    dependencies {
        // Add this line
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

**File: `android/app/build.gradle`**

Add at the bottom:

```gradle
apply plugin: 'com.google.gms.google-services'
```

Update `minSdkVersion` to at least 21:

```gradle
android {
    defaultConfig {
        minSdkVersion 21
    }
}
```

---

## 5. iOS Setup

### 5.1 Download GoogleService-Info.plist

1. In Firebase Console, download `GoogleService-Info.plist`
2. Open Xcode: `open ios/Runner.xcworkspace`
3. Drag `GoogleService-Info.plist` into `Runner/Runner` folder in Xcode
4. Make sure "Copy items if needed" is checked

### 5.2 Update iOS Configuration

**File: `ios/Runner/Info.plist`**

Add URL scheme for Google Sign-in (get REVERSED_CLIENT_ID from GoogleService-Info.plist):

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.YOUR-REVERSED-CLIENT-ID</string>
        </array>
    </dict>
</array>
```

### 5.3 Install Pods

```bash
cd ios
pod install
cd ..
```

---

## 6. Enable Firebase Services

### 6.1 Enable Authentication

1. Go to Firebase Console → **Authentication**
2. Click **Get Started**
3. Enable **Email/Password** provider
4. Enable **Google** provider
   - Add support email
   - Save

### 6.2 Create Firestore Database

1. Go to Firebase Console → **Firestore Database**
2. Click **Create Database**
3. Start in **Test Mode** (we'll add rules next)
4. Choose location closest to your users
5. Click **Enable**

### 6.3 Set Firestore Security Rules

Go to **Firestore Database → Rules** and paste:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // User-specific history
    match /users/{uid}/history/{docId} {
      allow read, write: if request.auth.uid == uid;
    }
    
    // User-specific rate alerts
    match /users/{uid}/alerts/{docId} {
      allow read, write: if request.auth.uid == uid;
    }
    
    // User preferences
    match /users/{uid}/preferences/{docId} {
      allow read, write: if request.auth.uid == uid;
    }
    
    // Feedback - authenticated users can write, no one can read
    match /feedback/{docId} {
      allow write: if request.auth != null;
      allow read: if false;
    }
    
    // Issue reports
    match /issues/{docId} {
      allow write: if request.auth != null;
      allow read: if false;
    }
  }
}
```

Click **Publish**.

### 6.4 Enable Cloud Messaging

1. Go to Firebase Console → **Cloud Messaging**
2. No additional setup needed for basic FCM
3. For iOS, you'll need to upload APNs certificate (for production)

---

## 7. Push Notifications Setup

### 7.1 Android Notification Configuration

**File: `android/app/src/main/AndroidManifest.xml`**

Add inside `<application>` tag:

```xml
<meta-data
    android:name="com.google.firebase.messaging.default_notification_channel_id"
    android:value="high_importance_channel" />

<meta-data
    android:name="com.google.firebase.messaging.default_notification_icon"
    android:resource="@drawable/ic_notification" />
```

### 7.2 iOS Notification Configuration

1. Open Xcode: `open ios/Runner.xcworkspace`
2. Select **Runner** → **Signing & Capabilities**
3. Click **+ Capability**
4. Add **Push Notifications**
5. Add **Background Modes** → Check **Remote notifications**

---

## 8. Test Firebase Integration

### 8.1 Test Authentication

Run your app and test:

```bash
flutter run
```

1. **Sign up** with email/password
2. Check Firebase Console → Authentication → Users (should see new user)
3. **Sign in** with the created account
4. Test **Google Sign-in**
5. Test **Password Reset**
6. Test **Sign out**

### 8.2 Test Firestore

1. Perform a currency conversion in the app
2. Go to Firebase Console → Firestore Database
3. Check if `users/{uid}/history` collection has data
4. Create a rate alert
5. Check if `users/{uid}/alerts` collection has data

### 8.3 Test Cloud Messaging

1. Get FCM token from app (printed in console)
2. Go to Firebase Console → Cloud Messaging → Send test message
3. Paste token and send
4. Verify notification appears on device

---

## 9. Troubleshooting

### Common Errors

#### "Missing google-services.json"
- **Solution**: Re-download from Firebase Console and place in `android/app/`

#### "SHA-1 incorrect" or Google Sign-in fails
- **Solution**: 
  1. Regenerate SHA-1: `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android`
  2. Add to Firebase Console → Project Settings → SHA fingerprints

#### "FirebaseAuthException: invalid-email"
- **Solution**: Check email format is valid

#### "FirebaseAuthException: weak-password"
- **Solution**: Password must be at least 6 characters

#### "PlatformException: sign_in_failed"
- **Solution**: 
  1. Verify SHA-1 is added to Firebase
  2. Check `google-services.json` is up to date
  3. Rebuild app: `flutter clean && flutter pub get && flutter run`

#### Firestore permission denied
- **Solution**: Check Firestore rules allow authenticated users to read/write their own data

#### Push notifications not working
- **Solution**:
  1. Check FCM is enabled in Firebase Console
  2. Verify notification permissions are granted
  3. For iOS, check APNs certificate is uploaded (production only)
  4. Check AndroidManifest.xml has notification metadata

#### iOS build fails
- **Solution**:
  1. Run `cd ios && pod install && cd ..`
  2. Clean build: `flutter clean`
  3. Open Xcode and check for signing issues

---

## 10. Production Checklist

Before releasing to production:

- [ ] Update Firestore rules to production-ready rules
- [ ] Add release SHA-1 fingerprint (Android)
- [ ] Upload APNs certificate (iOS)
- [ ] Enable Firebase Analytics
- [ ] Set up Firebase Crashlytics
- [ ] Configure rate limiting for APIs
- [ ] Add proper error logging
- [ ] Test on multiple devices
- [ ] Review Firebase billing limits

---

## 11. Useful Commands

```bash
# Check Flutter setup
flutter doctor

# Clean and rebuild
flutter clean
flutter pub get
flutter run

# Build release APK
flutter build apk --release

# Build iOS
flutter build ios --release

# Check Firebase configuration
flutterfire configure

# View Firebase logs
firebase functions:log
```

---

## 12. Additional Resources

- **Firebase Documentation**: https://firebase.google.com/docs
- **FlutterFire Documentation**: https://firebase.flutter.dev
- **Firebase Console**: https://console.firebase.google.com
- **Firebase CLI Reference**: https://firebase.google.com/docs/cli
- **Google Sign-in Setup**: https://firebase.google.com/docs/auth/android/google-signin

---

## Support

If you encounter issues:

1. Check Firebase Console for error messages
2. Review Flutter logs: `flutter logs`
3. Check Firebase status: https://status.firebase.google.com
4. Search Firebase documentation
5. Check Stack Overflow with tag `[firebase] [flutter]`

---

**Last Updated**: November 2024  
**Firebase SDK Version**: 2.25.0  
**Flutter Version**: 3.0+
