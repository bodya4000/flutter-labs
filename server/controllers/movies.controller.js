const { listMovies } = require('../services/movies.service');

async function list(req, res) {
  try {
    const movies = await listMovies();
    res.json({ movies });
  } catch (e) {
    res.status(500).json({ message: e.message || 'Error' });
  }
}

module.exports = { list };
