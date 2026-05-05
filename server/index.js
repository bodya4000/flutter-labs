require('dotenv').config({
  path: require('path').join(__dirname, '.env'),
});

const { startMqtt } = require('./mqttDaemon');
const { mountApp } = require('./expressApp');

startMqtt();
mountApp();
