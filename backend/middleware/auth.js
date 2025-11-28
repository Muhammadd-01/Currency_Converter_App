const admin = require('../config/firebase');

const verifyToken = async (req, res, next) => {
    const idToken = req.headers.authorization?.split('Bearer ')[1];
    if (!idToken) {
        return res.status(401).json({ error: 'No token provided' });
    }

    try {
        const decodedToken = await admin.auth().verifyIdToken(idToken);
        req.user = decodedToken;
        next();
    } catch (error) {
        console.error('Error verifying token:', error);
        res.status(401).json({ error: 'Unauthorized' });
    }
};

const verifySuperAdmin = async (req, res, next) => {
    await verifyToken(req, res, () => {
        if (req.user && req.user.superAdmin === true) {
            next();
        } else {
            res.status(403).json({ error: 'Requires Super Admin privileges' });
        }
    });
};

const verifyAdmin = async (req, res, next) => {
    await verifyToken(req, res, () => {
        if (req.user && (req.user.admin === true || req.user.superAdmin === true)) {
            next();
        } else {
            res.status(403).json({ error: 'Requires Admin privileges' });
        }
    });
};

module.exports = { verifySuperAdmin, verifyAdmin };
