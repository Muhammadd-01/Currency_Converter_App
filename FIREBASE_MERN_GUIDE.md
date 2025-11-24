# How to Connect Firebase to MERN Admin Panel

This guide explains how to connect your Firebase project to the MERN admin panel to view registered users.

## Prerequisites

- A Firebase project with Authentication enabled.
- Node.js installed on your machine.

## Step 1: Generate Firebase Service Account Key

1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Select your project.
3. Click on the **Gear icon** (Settings) > **Project settings**.
4. Go to the **Service accounts** tab.
5. Click **Generate new private key**.
6. Click **Generate key** to download the JSON file.
7. Rename this file to ` json`.

## Step 2: Configure the Backend

1. Move the `serviceAccountKey.json` file to the `backend` directory of this project.
   - Path: `Flutter_CurrencyConverter/backend/serviceAccountKey.json`
2. Create a `.env` file in the `backend` directory if it doesn't exist.
3. Add your MongoDB connection string (optional, defaults to local):
   ```env
   PORT=5000
   MONGO_URI=mongodb://localhost:27017/currency-converter-admin
   ```

## Step 3: Run the Backend

1. Open a terminal and navigate to the `backend` directory:
   ```bash
   cd backend
   ```
2. Install dependencies (if not already done):
   ```bash
   npm install
   ```
3. Start the server:
   ```bash
   npm start
   ```
   You should see:
   ```
   MongoDB Connected: ...
   Firebase Admin initialized successfully
   Server running on port 5000
   ```

## Step 4: Run the Admin Panel (Frontend)

1. Open a new terminal and navigate to the `admin-panel` directory:
   ```bash
   cd admin-panel
   ```
2. Install dependencies (if not already done):
   ```bash
   npm install
   ```
3. Start the development server:
   ```bash
   npm run dev
   ```
4. Open your browser and go to `http://localhost:5173`.

## Step 5: Verify Integration

1. Register a new user in your Flutter app.
2. Go to the Admin Panel in your browser.
3. Click on **Users**.
4. You should see the newly registered user in the list.

## Troubleshooting

- **"Firebase Admin not initialized"**: Make sure `serviceAccountKey.json` is in the `backend` folder and is valid.
- **"Failed to fetch users"**: Ensure the backend server is running on port 5000 and there are no CORS errors.
