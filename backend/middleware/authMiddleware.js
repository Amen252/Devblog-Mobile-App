const jwt = require('jose');
require('dotenv').config();
const User = require('../models/User');

const secret = new TextEncoder().encode(process.env.JWT_SECRET || 'secret123');
console.log('Middleware Secret Length:', secret.byteLength);

const protect = async (req, res, next) => {
    let token;

    if (
        req.headers.authorization &&
        req.headers.authorization.startsWith('Bearer')
    ) {
        try {
            // Get token from header
            token = req.headers.authorization.split(' ')[1];

            // Verify token
            const { payload } = await jwt.jwtVerify(token, secret, {
                algorithms: ['HS256']
            });

            // Get user from the token
            req.user = await User.findById(payload.id).select('-password');

            next();
        } catch (error) {
            console.error('Auth Error:', error);
            res.status(401).json({ message: 'Not authorized', error: error.message });
        }
    }

    if (!token) {
        res.status(401).json({ message: 'Not authorized, no token' });
    }
};

module.exports = { protect };
