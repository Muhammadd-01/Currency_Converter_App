const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const connectDB = require('./config/db');
const userRoutes = require('./routes/users');
const admin = require('./config/firebase');

dotenv.config();

// Connect to MongoDB
connectDB();

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

// Initialize Super Admin
const initializeSuperAdmin = async () => {
    try {
        const superAdminEmail = 'superadmin@currensee.com';
        const superAdminPassword = 'SuperAdmin123!'; // In production, use env var

        try {
            await admin.auth().getUserByEmail(superAdminEmail);
            console.log('Super Admin already exists');
        } catch (error) {
            if (error.code === 'auth/user-not-found') {
                const userRecord = await admin.auth().createUser({
                    email: superAdminEmail,
                    password: superAdminPassword,
                    displayName: 'Super Admin',
                });
                await admin.auth().setCustomUserClaims(userRecord.uid, { superAdmin: true, admin: true });
                console.log('Super Admin created successfully');
                console.log(`Email: ${superAdminEmail}`);
                console.log(`Password: ${superAdminPassword}`);
            } else {
                throw error;
            }
        }
    } catch (error) {
        console.error('Error initializing Super Admin:', error);
        if (error.code === 'app/invalid-credential' || error.message.includes('invalid_grant')) {
            console.error('\n\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
            console.error('CRITICAL ERROR: YOUR FIREBASE SERVICE ACCOUNT KEY IS INVALID OR EXPIRED.');
            console.error('Please go to Firebase Console -> Project Settings -> Service accounts');
            console.error('Click "Generate new private key" and replace the serviceAccountKey.json file.');
            console.error('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n\n');
        }
    }
};

initializeSuperAdmin();

// Routes
app.use('/api/users', userRoutes);
app.use('/api/data', require('./routes/data'));
app.use('/api/admins', require('./routes/admins'));
app.use('/api/history', require('./routes/history'));

app.get('/', (req, res) => {
    res.send('Currency Converter Admin API is running');
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
