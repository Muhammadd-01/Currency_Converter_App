const express = require('express');
const router = express.Router();
const admin = require('../config/firebase');

// Get all feedback
router.get('/feedback', async (req, res) => {
    try {
        const snapshot = await admin.firestore().collection('feedback').orderBy('timestamp', 'desc').get();
        const feedback = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
        res.json(feedback);
    } catch (error) {
        console.error('Error fetching feedback:', error);
        res.status(500).json({ error: 'Failed to fetch feedback' });
    }
});

// Get all issues
router.get('/issues', async (req, res) => {
    try {
        const snapshot = await admin.firestore().collection('issues').orderBy('timestamp', 'desc').get();
        const issues = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
        res.json(issues);
    } catch (error) {
        console.error('Error fetching issues:', error);
        res.status(500).json({ error: 'Failed to fetch issues' });
    }
});

module.exports = router;
