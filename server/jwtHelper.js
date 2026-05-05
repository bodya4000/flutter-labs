const jwt = require('jsonwebtoken');

function secret() {
  return process.env.JWT_SECRET || 'unik_lab5_dev_secret';
}

function signUser(userId, email) {
  return jwt.sign({ sub: String(userId), email }, secret(), {
    expiresIn: process.env.JWT_EXPIRES || '14d',
  });
}

function parseBearer(authHeader) {
  if (!authHeader || typeof authHeader !== 'string') {
    return null;
  }
  if (!authHeader.startsWith('Bearer ')) {
    return null;
  }
  return authHeader.slice(7);
}

function verifyToken(token) {
  return jwt.verify(token, secret());
}

module.exports = { signUser, parseBearer, verifyToken };
