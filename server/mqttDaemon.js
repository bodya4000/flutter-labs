const mqtt = require('mqtt');
const cron = require('node-cron');

const topics = {
  temperature: 'sensor/temperature',
  humidity: 'sensor/humidity',
  electricity: 'sensor/electricity',
  light: 'sensor/light',
};

const log = (label, payload) => {
  const ts = new Date().toISOString();
  if (payload !== undefined) {
    console.log(`[${ts}] [mqtt] ${label}`, payload);
    return;
  }
  console.log(`[${ts}] [mqtt] ${label}`);
};

let client;

function startMqtt() {
  const MQTT_URL = process.env.MQTT_URL || 'mqtt://127.0.0.1:1883';
  log('connecting', { MQTT_URL });

  client = mqtt.connect(MQTT_URL);

  client.on('connect', () => {
    log('connected', { clientId: client.options.clientId });
  });
  client.on('error', (err) =>
    log('error', { message: err.message, code: err.code }),
  );
  client.on('offline', () => log('offline'));
  client.on('close', () => log('socket closed'));

  function publishTelemetry() {
    if (!client.connected) {
      log('publish skip — not connected');
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
    log('published', {
      temperature: `${t.toFixed(1)} °C`,
      humidity: `${h.toFixed(1)} %`,
      electricity: `${e.toFixed(2)} kW`,
      light: `${l.toFixed(0)} lux`,
    });
  }

  cron.schedule('*/10 * * * * *', publishTelemetry);
  log('cron every 10s');
}

function mqttConnected() {
  return Boolean(client && client.connected);
}

module.exports = { startMqtt, mqttConnected, topics };
