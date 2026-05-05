require('dotenv').config({
  path: require('path').join(__dirname, '.env'),
});
const express = require('express');
const cors = require('cors');

const api = require('./routes/api.routes');
const { mqttConnected, topics } = require('./mqttDaemon');

const PORT = Number(process.env.PORT || '3000');

function mountApp() {
  const app = express();
  app.use(cors({ origin: true }));
  app.use(express.json());

  app.get('/health', (_req, res) => {
    res.json({
      mqtt: mqttConnected(),
      topics,
      ok: true,
    });
  });

  app.use('/api', api);

  app.listen(PORT, () => {
    const ts = new Date().toISOString();
    console.log(`[${ts}] [http] listening on http://127.0.0.1:${PORT}`);
  });
}

module.exports = { mountApp };
