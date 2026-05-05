const express = require('express');
const { authMiddleware } = require('../middleware/authMiddleware');
const auth = require('../controllers/auth.controller');
const movies = require('../controllers/movies.controller');

const router = express.Router();

router.post('/auth/register', auth.register);
router.post('/auth/login', auth.login);
router.patch('/auth/me', authMiddleware, auth.patchMe);
router.delete('/auth/me', authMiddleware, auth.deleteMe);
router.get('/movies', authMiddleware, movies.list);

module.exports = router;
