const { verifyToken, parseBearer } = require('../jwtHelper');

function authMiddleware(req, res, next) {
  try {
    const token = parseBearer(req.headers.authorization);
    if (!token) {
      return res.status(401).json({ message: 'Unauthorized' });
    }
    const payload = verifyToken(token);
    req.userId = Number(payload.sub);
    req.userEmail = payload.email;
    next();
  } catch (_) {
    return res.status(401).json({ message: 'Unauthorized' });
  }
}

module.exports = { authMiddleware };
