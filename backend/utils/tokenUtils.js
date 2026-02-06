const jwt = require('jose');
require('dotenv').config();

const accessSecret = new TextEncoder().encode(process.env.JWT_SECRET || 'secret123');
console.log('TokenUtils Secret Length:', accessSecret.byteLength);
const refreshSecret = new TextEncoder().encode(process.env.JWT_REFRESH_SECRET || 'refreshSecret123');

const generateAccessToken = async (userId) => {
    return await new jwt.SignJWT({ id: userId.toString() })
        .setProtectedHeader({ alg: 'HS256' })
        .setExpirationTime('15m')
        .sign(accessSecret);
};

const generateRefreshToken = async (userId) => {
    return await new jwt.SignJWT({ id: userId.toString() })
        .setProtectedHeader({ alg: 'HS256' })
        .setExpirationTime('7d')
        .sign(refreshSecret);
};

const verifyRefreshToken = async (token) => {
    try {
        const { payload } = await jwt.jwtVerify(token, refreshSecret);
        return payload;
    } catch (error) {
        return null;
    }
};

module.exports = {
    generateAccessToken,
    generateRefreshToken,
    verifyRefreshToken,
};
