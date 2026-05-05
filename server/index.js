const express = require('express');
const mqtt = require('mqtt');
const cron = require('node-cron');

const MQTT_URL = process.env.MQTT_URL || 'mqtt://127.0.0.1:1883';
const PORT = Number(process.env.PORT || '3000');

const topics = {
  temperature: 'sensor/temperature',
  humidity: 'sensor/humidity',
  electricity: 'sensor/electricity',
  light: 'sensor/light',
};

const log = (label, payload) => {
  const ts = new Date().toISOString();
  if (payload !== undefined) {
    console.log(`[${ts}] [server] ${label}`, payload);
    return;
  }
  console.log(`[${ts}] [server] ${label}`);
};

log('starting', { MQTT_URL, PORT, topics });

const app = express();

const client = mqtt.connect(MQTT_URL);

client.on('connect', () => {
  log('mqtt connected', { broker: MQTT_URL, clientId: client.options.clientId });
});

client.on('error', (err) => {
  log('mqtt error', { message: err.message, code: err.code });
});

client.on('offline', () => {
  log('mqtt offline (socket closed or broker unreachable)');
});

client.on('disconnect', () => {
  log('mqtt disconnect packet from broker');
});

client.on('reconnect', () => {
  log('mqtt reconnect attempt');
});

client.on('close', () => {
  log('mqtt connection closed');
});

function publishTelemetry() {
  if (!client.connected) {
    log('telemetry skip: mqtt not connected');
    return;
  }
  const qos = { qos: 1 };
  const t = 18 + Math.random() * 12;
  const h = 40 + Math.random() * 40;
  const e = 0.5 + Math.random() * 3;
  const l = 200 + Math.random() * 800;
  client.publish(topics.temperature, t.toFixed(1), qos);
  client.publish(topics.humidity, h.toFixed(1), qos);
  client.publish(topics.electricity, e.toFixed(2), qos);
  client.publish(topics.light, l.toFixed(0), qos);
  log('telemetry published', {
    temperature: `${t.toFixed(1)} °C`,
    humidity: `${h.toFixed(1)} %`,
    electricity: `${e.toFixed(2)} kW`,
    light: `${l.toFixed(0)} lux`,
  });
}

cron.schedule('*/10 * * * * *', publishTelemetry);
log('cron scheduled', { pattern: '*/10 * * * * *', note: 'every 10 seconds' });

app.get('/health', (_req, res) => {
  res.json({
    mqtt: Boolean(client.connected),
    topics,
    ok: true,
  });
});

app.listen(PORT, () => {
  log(`HTTP listening`, { url: `http://127.0.0.1:${PORT}`, path: '/health' });
});
