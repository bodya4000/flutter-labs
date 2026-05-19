const {
  registerUser,
  loginUser,
  updateUser,
  deleteUser,
} = require('../services/auth.service');

async function register(req, res) {
  try {
    const { email, password, fullName, nickname } = req.body;
    if (!email || !password || !fullName) {
      return res.status(400).json({ message: 'Missing email, password or fullName' });
    }
    const out = await registerUser({ email, password, fullName, nickname });
    res.status(201).json(out);
  } catch (e) {
    res.status(e.status || 500).json({ message: e.message || 'Error' });
  }
}

async function login(req, res) {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({ message: 'Missing email or password' });
    }
    const out = await loginUser(email, password);
    res.json(out);
  } catch (e) {
    res.status(e.status || 500).json({ message: e.message || 'Error' });
  }
}

async function patchMe(req, res) {
  try {
    const { fullName, email, nickname, password } = req.body;
    const body = {};
    if (fullName !== undefined) {
      body.fullName = fullName;
    }
    if (email !== undefined) {
      body.email = email;
    }
    if (nickname !== undefined) {
      body.nickname = nickname;
    }
    if (password !== undefined) {
      body.password = password;
    }
    const user = await updateUser(req.userId, body);
    res.json({ user });
  } catch (e) {
    res.status(e.code === 'P2002' ? 409 : 500).json({
      message: e.message || 'Error',
    });
  }
}

async function deleteMe(req, res) {
  try {
    await deleteUser(req.userId);
    res.status(204).send();
  } catch (e) {
    res.status(500).json({ message: e.message || 'Error' });
  }
}

module.exports = { register, login, patchMe, deleteMe };
