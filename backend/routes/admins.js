const express = require('express');
const router = express.Router();
const admin = require('../config/firebase');

const { verifySuperAdmin } = require('../middleware/auth');

// Get all admins
router.get('/', verifySuperAdmin, async (req, res) => {
    try {
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
router.post('/', verifySuperAdmin, async (req, res) => {
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
router.delete('/:uid', verifySuperAdmin, async (req, res) => {
    try {
        const { uid } = req.params;

        // Prevent deleting self
        if (req.user.uid === uid) {
            return res.status(403).json({ error: 'Cannot delete yourself' });
        }

        // Check if target is Super Admin
        const user = await admin.auth().getUser(uid);
        if (user.customClaims && user.customClaims.superAdmin === true) {
            return res.status(403).json({ error: 'Cannot delete Super Admin' });
        }

        await admin.auth().deleteUser(uid);
        res.json({ message: 'Admin deleted successfully' });
    } catch (error) {
        console.error('Error deleting admin:', error);
        res.status(500).json({ error: 'Failed to delete admin' });
    }
});

module.exports = router;
