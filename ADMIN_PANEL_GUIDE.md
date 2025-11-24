# Admin Panel & Firebase Setup Guide

This comprehensive guide explains how to set up the Admin Panel, connect it to Firebase, and run the entire system.

## 1. Firebase Connection (CRITICAL)
To allow the Admin Panel to manage users and read data, you must provide it with administrative credentials.

1.  **Go to Firebase Console**: Open your project in the [Firebase Console](https://console.firebase.google.com/).
2.  **Project Settings**: Click the gear icon ⚙️ -> Project settings.
3.  **Service Accounts**: Go to the "Service accounts" tab.
4.  **Generate Key**: Click "Generate new private key".
5.  **Save File**: A file will download. Rename it to `serviceAccountKey.json`.
6.  **Place File**: Move this file into the `backend` folder of your project.
    *   Path: `Currency_Converter_App/backend/serviceAccountKey.json`

> [!IMPORTANT]
> Without this file, the Admin Panel will show "Firebase Admin not initialized" and will not work.

## 2. Backend Setup
The backend serves as the bridge between the Admin Panel and Firebase.

1.  Open a terminal in the `backend` folder.
2.  Install dependencies:
    ```bash
    npm install
    ```
3.  Start the server:
    ```bash
    node server.js
    ```
    *   You should see: `Server running on port 5000` and `Firebase Admin initialized successfully`.

## 3. Admin Panel (Frontend) Setup
The Admin Panel is the visual interface for managing your app.

1.  Open a **new** terminal in the `admin-panel` folder.
2.  Install dependencies:
    ```bash
    npm install
    ```
3.  Start the development server:
    ```bash
    npm run dev
    ```
4.  Open the link shown (e.g., `http://localhost:5173`).

## 4. Features & Usage
The Admin Panel now includes:
-   **Dashboard**: Overview of total users and system status.
-   **Users**: List of all registered users. You can **delete** users here.
-   **Feedback**: View feedback submitted by users from the app.
-   **Issues**: View bug reports and issues submitted by users.

## 5. Troubleshooting Common Issues

### Build Failed (java.io.IOException)
If you see "Unable to delete directory" when running the Flutter app:
1.  **Stop everything**: Close the emulator and any running terminals.
2.  **Kill Java**: Open Task Manager and end any `java.exe` or `OpenJDK Platform binary` processes.
3.  **Clean**: Run `flutter clean` in the root directory.
4.  **Rebuild**: Run `flutter run`.

### CSS Not Showing
If the Admin Panel looks unstyled:
1.  Ensure you are running `npm run dev` inside `admin-panel`.
2.  Try restarting the `npm run dev` server.
3.  Hard refresh your browser (Ctrl+F5).

### Data Not Showing
If the tables are empty:
1.  Check the backend terminal. If it says "Error listing users", check your `serviceAccountKey.json`.
2.  Ensure your Flutter app is actually sending data to the `feedback` or `issues` collections in Firestore.
