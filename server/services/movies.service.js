const { prisma } = require('../prismaClient');

async function listMovies() {
  return prisma.movie.findMany({ orderBy: { id: 'asc' } });
}

module.exports = { listMovies };
