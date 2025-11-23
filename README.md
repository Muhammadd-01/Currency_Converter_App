# CurrenSee 💱

A modern, feature-rich Flutter currency conversion app with Firebase integration, real-time exchange rates, and a premium gradient UI.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Firebase](https://img.shields.io/badge/Firebase-Integrated-orange.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## ✨ Features

- 🔐 **Firebase Authentication** - Email/Password & Google Sign-in
- 💱 **Real-time Currency Conversion** - 40+ currencies supported
- 📊 **Historical Rate Charts** - 7/30/90 day charts with fl_chart
- 📜 **Conversion History** - All conversions saved to Firestore
- 🔔 **Rate Alerts** - Get notified when rates meet your threshold
- 📰 **Currency News** - Latest financial news integration
- ⚙️ **User Preferences** - Customizable settings
- 🎨 **Premium UI** - Gradient backgrounds, glassmorphism, smooth animations
- 🔔 **Push Notifications** - Firebase Cloud Messaging integration
- 💬 **Feedback System** - In-app feedback with ratings

## 🚀 Quick Start

### Prerequisites

- Flutter SDK (3.0+)
- Firebase account
- Node.js (for Firebase CLI)

### Installation

1. **Clone the repository**
   ```bash
   cd /Users/muhammadaffan/Coding/Flutter_CurrencyConverter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   ```bash
   # Install Firebase CLI
   npm install -g firebase-tools
   
   # Login to Firebase
   firebase login
   
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure Firebase
   flutterfire configure
   ```

4. **Enable Firebase services**
   - Go to [Firebase Console](https://console.firebase.google.com)
   - Enable Authentication (Email/Password, Google)
   - Create Firestore Database
   - Enable Cloud Messaging

5. **Run the app**
   ```bash
   flutter run
   ```

## 📖 Documentation

- **[Firebase Setup Guide](FIREBASE_SETUP_GUIDE.md)** - Complete Firebase configuration steps
- **[Walkthrough](walkthrough.md)** - Detailed feature documentation

## 🏗️ Project Structure

```
lib/
├── main.dart                    # App entry point
├── theme/                       # App theme & styling
├── widgets/                     # Reusable UI components
├── models/                      # Data models
├── services/                    # Firebase & API services
└── screens/                     # App screens
    ├── auth/                    # Authentication screens
    ├── home/                    # Main app screens
    └── settings/                # Settings & profile
```

## 🎨 UI Components

- **Gradient Backgrounds** - Animated gradient backgrounds
- **Glass Cards** - Glassmorphism effect cards
- **Gradient Buttons** - Beautiful gradient-filled buttons
- **Smooth Animations** - Page transitions and micro-animations

## 🔧 Technologies Used

- **Flutter** - Cross-platform mobile framework
- **Firebase Auth** - User authentication
- **Cloud Firestore** - NoSQL database
- **Firebase Cloud Messaging** - Push notifications
- **fl_chart** - Beautiful charts
- **Phosphor Icons** - Modern icon set
- **exchangerate.host** - Exchange rate API

## 📱 Screens

1. **Authentication**
   - Login
   - Signup
   - Password Reset

2. **Main App**
   - Currency Converter
   - Conversion History
   - Rate Alerts
   - Currency News
   - Settings
   - Profile

## 🔐 Security

All user data is secured with Firestore security rules. Users can only access their own data.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License.

## 🙏 Acknowledgments

- [exchangerate.host](https://exchangerate.host) - Free exchange rate API
- [NewsAPI](https://newsapi.org) - News API
- [Firebase](https://firebase.google.com) - Backend services
- [Flutter](https://flutter.dev) - Amazing framework

## 📞 Support

For issues and questions:
- Check the [Firebase Setup Guide](FIREBASE_SETUP_GUIDE.md)
- Open an issue on GitHub
- Email: support@currensee.com

---

**Made with ❤️ using Flutter & Firebase**
