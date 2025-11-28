const express = require('express');
const router = express.Router();
const admin = require('../config/firebase');

const { verifyAdmin } = require('../middleware/auth');

router.get('/', verifyAdmin, async (req, res) => {
    try {
        if (!admin.apps.length) {
            return res.status(503).json({ error: 'Firebase Admin not initialized' });
        }

        const listUsersResult = await admin.auth().listUsers(1000);
        const users = listUsersResult.users.map(userRecord => ({
            uid: userRecord.uid,
            email: userRecord.email,
            displayName: userRecord.displayName,
            photoURL: userRecord.photoURL,
            creationTime: userRecord.metadata.creationTime,
            lastSignInTime: userRecord.metadata.lastSignInTime,
            customClaims: userRecord.customClaims
        }));
        res.json(users);
    } catch (error) {
        console.error('Error listing users:', error);
        res.status(500).json({ error: 'Failed to list users' });
    }
});

router.delete('/:uid', verifyAdmin, async (req, res) => {
    try {
        const { uid } = req.params;

        // Check if target is Super Admin
        const user = await admin.auth().getUser(uid);
        if (user.customClaims && user.customClaims.superAdmin === true) {
            return res.status(403).json({ error: 'Cannot delete Super Admin' });
        }

        await admin.auth().deleteUser(uid);
        res.json({ message: 'User deleted successfully' });
    } catch (error) {
        console.error('Error deleting user:', error);
        res.status(500).json({ error: 'Failed to delete user' });
    }
});

module.exports = router;
