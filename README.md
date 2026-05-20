# 💬 Flutter Chat App

A real-time chat application built with Flutter, Firebase, and Cloudinary.

---

## 📱 Features

- 🔐 Email & Password Authentication (Firebase Auth)
- 👤 User Profile with Photo Upload (Cloudinary)
- 📋 All Users List with Online/Offline Status
- 💬 Real-time One-to-One Chat (Firestore)
- 🟢 Online/Offline Status & Last Seen
- 📦 State Management with GetX

---

## 🛠️ Tech Stack

| Technology | Purpose |
|------------|---------|
| Flutter | UI Framework |
| Firebase Auth | User Authentication |
| Cloud Firestore | Real-time Database |
| Cloudinary | Profile Image Storage |
| GetX | State Management & Navigation |
| FCM | Push Notifications (Coming Soon) |

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8

  # Firebase
  firebase_core: ^3.1.1
  firebase_auth: ^5.1.4
  cloud_firestore: ^5.1.0
  firebase_messaging: ^15.0.3

  # State Management
  get: ^4.6.6

  # Image
  cloudinary_public: ^0.23.1
  image_picker: ^1.1.2

  # Notifications
  flutter_local_notifications: ^17.2.2
```

---

## 📁 Project Structure

```
lib/
├── main.dart
├── models/
│   ├── user_model.dart         # User data model
│   └── message_model.dart      # Message data model
├── services/
│   ├── cloudinary_service.dart # Image upload service
│   └── chat_service.dart       # Firestore chat service
├── controllers/
│   ├── auth_controller.dart    # Auth logic (GetX)
│   └── chat_controller.dart    # Chat logic (GetX)
└── ui/
    ├── login_screen.dart       # Login screen
    ├── register_screen.dart    # Register screen
    ├── home_screen.dart        # Users list screen
    └── chat_screen.dart        # Chat screen
```

---

## 🔥 Firebase Setup

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project
3. Enable **Authentication** → Email/Password
4. Enable **Cloud Firestore**
5. Download `google-services.json` and place it in `android/app/`
6. Run:

```bash
flutterfire configure
```

### Firestore Rules

```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }
    match /chats/{chatId}/messages/{messageId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

---

## ☁️ Cloudinary Setup

1. Create account at [cloudinary.com](https://cloudinary.com)
2. Go to **Settings → Upload → Upload Presets**
3. Click **Add Upload Preset**
4. Set:
   - Preset Name: `flutter_upload`
   - Signing Mode: `Unsigned`
5. Save

Update your Cloud Name in `cloudinary_service.dart`:

```dart
final CloudinaryPublic _cloudinary = CloudinaryPublic(
  'YOUR_CLOUD_NAME',   // 👈 replace this
  'flutter_upload',
  cache: false,
);
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK installed
- Android Studio / VS Code
- Firebase project setup
- Cloudinary account setup

### Installation

```bash
# 1. Clone the repo
git clone https://github.com/YOUR_USERNAME/flutter-chat-app.git

# 2. Go into the project
cd flutter-chat-app

# 3. Install dependencies
flutter pub get

# 4. Run the app
flutter run
```

---

## 🗄️ Firestore Data Structure

```
users/
  └── {uid}/
        ├── uid: String
        ├── name: String
        ├── email: String
        ├── photoUrl: String
        ├── isOnline: Boolean
        └── lastSeen: Timestamp

chats/
  └── {chatRoomId}/
        └── messages/
              └── {messageId}/
                    ├── messageId: String
                    ├── senderId: String
                    ├── message: String
                    └── timestamp: Timestamp
```

---

## 📸 Screenshots

> Add your app screenshots here

---

## 🔮 Coming Soon

- [ ] FCM Push Notifications
- [ ] Image sharing in chat
- [ ] Message delete
- [ ] Group chat

---

## 👨‍💻 Author

**Muhammad Hasaan Altaf**

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
