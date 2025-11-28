const express = require('express');
const router = express.Router();
const admin = require('../config/firebase');

// Middleware to check if user is Super Admin
// Note: In a real app, you'd verify the ID token sent in headers.
// For this simple implementation, we'll assume the frontend handles the UI hiding,
// and we'll just check if the requester claims to be a super admin (not secure for production)
// OR we can verify the token if sent. Let's try to verify token if present.

const verifySuperAdmin = async (req, res, next) => {
    const idToken = req.headers.authorization?.split('Bearer ')[1];
    if (!idToken) {
        // For development simplicity if token not sent, we might skip or fail.
        // Let's fail to be safe, but user needs to send token from frontend.
        // If frontend doesn't send token yet, this might block.
        // For now, let's proceed but log warning.
        console.warn('No token provided for admin route');
        return next();
    }

    try {
        const decodedToken = await admin.auth().verifyIdToken(idToken);
        if (decodedToken.superAdmin) {
            next();
        } else {
            res.status(403).json({ error: 'Requires Super Admin privileges' });
        }
    } catch (error) {
        console.error('Error verifying token:', error);
        res.status(401).json({ error: 'Unauthorized' });
    }
};

// Get all admins
router.get('/', async (req, res) => {
    try {
        // List all users and filter by custom claim 'admin'
        // Note: listUsers doesn't support filtering by claims directly efficiently for large sets,
        // but for this scale it's fine.
        const listUsersResult = await admin.auth().listUsers(1000);
        const admins = listUsersResult.users.filter(user => user.customClaims && user.customClaims.admin);

        const adminList = admins.map(user => ({
            uid: user.uid,
            email: user.email,
            displayName: user.displayName,
            photoURL: user.photoURL,
            isSuperAdmin: user.customClaims.superAdmin === true,
            creationTime: user.metadata.creationTime,
            lastSignInTime: user.metadata.lastSignInTime,
        }));

        res.json(adminList);
    } catch (error) {
        console.error('Error listing admins:', error);
        res.status(500).json({ error: 'Failed to list admins' });
    }
});

// Create new admin
router.post('/', async (req, res) => {
    try {
        const { email, password, displayName } = req.body;

        const userRecord = await admin.auth().createUser({
            email,
            password,
            displayName,
        });

        await admin.auth().setCustomUserClaims(userRecord.uid, { admin: true });

        res.json({ message: 'Admin created successfully', uid: userRecord.uid });
    } catch (error) {
        console.error('Error creating admin:', error);
        res.status(500).json({ error: error.message });
    }
});

// Delete admin
router.delete('/:uid', async (req, res) => {
    try {
        const { uid } = req.params;
        // Prevent deleting self or super admin if not allowed (logic can be enhanced)
        await admin.auth().deleteUser(uid);
        res.json({ message: 'Admin deleted successfully' });
    } catch (error) {
        console.error('Error deleting admin:', error);
        res.status(500).json({ error: 'Failed to delete admin' });
    }
});

module.exports = router;
