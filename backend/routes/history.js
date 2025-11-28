const express = require('express');
const router = express.Router();
const admin = require('../config/firebase');

// Get history for a specific user
router.get('/:userId', async (req, res) => {
    try {
        const { userId } = req.params;
        const snapshot = await admin.firestore()
            .collection('users')
            .doc(userId)
            .collection('history')
            .orderBy('timestamp', 'desc')
            .limit(50)
            .get();

        const history = snapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data(),
            timestamp: doc.data().timestamp ? doc.data().timestamp.toDate() : null
        }));

        res.json(history);
    } catch (error) {
        console.error('Error fetching history:', error);
        res.status(500).json({ error: 'Failed to fetch history' });
    }
});

module.exports = router;
