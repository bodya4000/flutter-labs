const bcrypt = require('bcryptjs');
const { prisma } = require('../prismaClient');
const { signUser } = require('../jwtHelper');

function normalizeEmail(value) {
  const s = String(value ?? '').trim().toLowerCase();
  if (!s) {
    const err = new Error('Invalid email');
    err.status = 400;
    throw err;
  }
  return s;
}

async function registerUser({ email, password, fullName, nickname }) {
  const normalized = normalizeEmail(email);
  const dup = await prisma.user.findFirst({ where: { email: normalized } });
  if (dup) {
    const err = new Error('Email already registered');
    err.status = 409;
    throw err;
  }
  const passwordHash = await bcrypt.hash(password, 11);
  const user = await prisma.user.create({
    data: {
      email: normalized,
      passwordHash,
      fullName: fullName.trim(),
      nickname: nickname?.trim() || null,
    },
  });
  const token = signUser(user.id, user.email);
  return { token, user: publicUser(user) };
}

async function loginUser(email, password) {
  const normalized = normalizeEmail(email);
  const user = await prisma.user.findFirst({ where: { email: normalized } });
  if (!user) {
    const err = new Error('Invalid email or password');
    err.status = 401;
    throw err;
  }
  const ok = await bcrypt.compare(password, user.passwordHash);
  if (!ok) {
    const err = new Error('Invalid email or password');
    err.status = 401;
    throw err;
  }
  const token = signUser(user.id, user.email);
  return { token, user: publicUser(user) };
}

async function updateUser(userId, { fullName, email, nickname, password }) {
  const id = Number(userId);
  const data = {};
  if (fullName != null) {
    data.fullName = fullName.trim();
  }
  if (nickname !== undefined) {
    data.nickname = nickname?.trim() || null;
  }
  if (email != null) {
    data.email = normalizeEmail(email);
  }
  if (password && password.length) {
    data.passwordHash = await bcrypt.hash(password, 11);
  }
  const updated = await prisma.user.update({
    where: { id },
    data,
  });
  return publicUser(updated);
}

async function deleteUser(userId) {
  await prisma.user.delete({
    where: { id: Number(userId) },
  });
}

function publicUser(u) {
  return {
    id: u.id,
    email: u.email,
    fullName: u.fullName,
    nickname: u.nickname,
  };
}

async function userById(id) {
  return prisma.user.findUnique({ where: { id: Number(id) } });
}

module.exports = {
  registerUser,
  loginUser,
  updateUser,
  deleteUser,
  publicUser,
  userById,
};
