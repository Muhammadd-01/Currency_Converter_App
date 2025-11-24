const admin = require('firebase-admin');
const path = require('path');
const fs = require('fs');

try {
    const serviceAccountPath = path.join(__dirname, '../serviceAccountKey.json');

    if (fs.existsSync(serviceAccountPath)) {
        const serviceAccount = require(serviceAccountPath);
        admin.initializeApp({
            credential: admin.credential.cert(serviceAccount)
        });
        console.log('Firebase Admin initialized successfully');
    } else {
        console.warn('Warning: serviceAccountKey.json not found in backend directory. Firebase features will not work.');
        // Initialize with default credentials (for Google Cloud environment) or mock
        // admin.initializeApp(); 
    }
} catch (error) {
    console.error('Error initializing Firebase Admin:', error);
}

module.exports = admin;
