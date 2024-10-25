'use strict';

const Hapi = require('hapi');
const request = require('request');
const client = require('prom-client');  // Prometheus client

// Create Prometheus metrics
const collectDefaultMetrics = client.collectDefaultMetrics;
collectDefaultMetrics({ timeout: 5000 });  // Collect default metrics every 5 seconds

const httpRequestCounter = new client.Counter({
  name: 'happy_http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'endpoint', 'status']
});

const httpDuration = new client.Histogram({
  name: 'happy_http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'endpoint', 'status']
});

const httpErrorCounter = new client.Counter({
  name: 'http_errors_total',
  help: 'Total number of HTTP errors',
  labelNames: ['method', 'endpoint', 'status']
});

// Initialize the server
const server = Hapi.server({
    port: 4000,
    routes: { cors: { origin: ['*'] } },
    host: '0.0.0.0'
});

// Middleware to track request metrics
server.ext('onRequest', (request, h) => {
  const end = httpDuration.startTimer();  // Start timer
  request.app.startTime = end;
  return h.continue;
});

server.ext('onPreResponse', (request, h) => {
  const { response } = request;
  const statusCode = response.isBoom ? response.output.statusCode : response.statusCode;

  httpRequestCounter.labels(request.method.toUpperCase(), request.path, statusCode).inc();  // Increment counter
  request.app.startTime({ method: request.method.toUpperCase(), endpoint: request.path, status: statusCode });  // End timer

  if (statusCode >= 400) {
    httpErrorCounter.labels(request.method.toUpperCase(), request.path, statusCode).inc();  // Increment error counter
  }

  return h.continue;
});

// Define routes
server.route({
    method: 'GET',
    path: '/api/happy/',
    handler: (request, h) => {
        return 'Hey folks, I am HAPI!';
    }
});

server.route({
    method: 'GET',
    path: '/api/happy/{name}',
    handler: (request, h) => {
        console.log("just a test!");
        return 'Hello, ' + encodeURIComponent(request.params.name) + '!';
    }
});

server.route({
  method: 'GET',
  path: '/api/happy/multiply',
  handler: (request, h) => {
    const params = request.query;
    const result = params.num1 * params.num2;

    postToBootStorage(params.num1, params.num2, '*', result);
    return result;
  }
});

server.route({
  method: 'GET',
  path: '/api/happy/divide',
  handler: (request, h) => {
    const params = request.query;
    const result = params.num1 / params.num2;
    postToBootStorage(params.num1, params.num2, '/', result);
    return result;
  }
});

server.route({
  method: 'GET',
  path: '/api/happy/modulos',
  handler: (request, h) => {
    const params = request.query;
    const result = params.num1 % params.num2;
    postToBootStorage(params.num1, params.num2, '%', result);
    return result;
  }
});

// Expose /metrics endpoint for Prometheus scraping
server.route({
  method: 'GET',
  path: '/metrics',
  handler: async (request, h) => {
    try {
      return h.response(await client.register.metrics()).type(client.register.contentType);
    } catch (err) {
      return h.response(err.message).code(500);
    }
  }
});

server.route({
    method: 'GET',
    path: '/api/happy/healthz',
    handler: (request, h) => {
        return 'I am healthy!';
    }
});

/*
  Method to send post request to Spring Boot microservice
*/
function postToBootStorage(num1, num2, operation, result) {
  var data = {
    "num1": num1,
    "num2": num2,
    "op": operation,
    "result": result
  };

  request({
    url: "http://34.116.237.107/api/bootstorage/create",
    method: "POST",
    json: true,
    body: data
  }, function (error, response, body) {
    console.log("Received response from Spring Boot service 'bootstorage'");
    if (error) {
      console.log("error = " + error);
    }
    if (process.env.LOG_LEVEL == 'DEBUG') {
      console.log("body = " + JSON.stringify(body));
    }
  });
}

// Start the server
const init = async () => {
    await server.start();
    console.log(`Server running at: ${server.info.uri}`);
};

process.on('unhandledRejection', (err) => {
    console.log(err);
    process.exit(1);
});

init();
