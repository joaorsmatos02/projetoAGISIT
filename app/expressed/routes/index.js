var express = require('express');
var router = express.Router();
var request = require('request');
const client = require('prom-client');  // Prometheus client

// Create Prometheus metrics
const collectDefaultMetrics = client.collectDefaultMetrics;
collectDefaultMetrics({ timeout: 5000 });  // Collect default metrics every 5 seconds

const httpRequestCounter = new client.Counter({
  name: 'express_http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'endpoint', 'status']
});
const httpDuration = new client.Histogram({
  name: 'express_http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'endpoint', 'status']
});

const httpErrorCounter = new client.Counter({
  name: 'express_http_requests_errors_total',
  help: 'Total number of HTTP errors',
  labelNames: ['method', 'endpoint', 'status']
});

// Middleware to track request metrics and errors
router.use((req, res, next) => {
  const end = httpDuration.startTimer();  // Start timer
  res.on('finish', () => {
    httpRequestCounter.labels(req.method, req.path, res.statusCode).inc();  // Increment request counter
    end({ method: req.method, endpoint: req.path, status: res.statusCode });  // End timer

    // Track errors: increment error counter if status code indicates an error (4xx or 5xx)
    if (res.statusCode >= 400) {
      httpErrorCounter.labels(req.method, req.path, res.statusCode).inc();  // Increment error counter
    }
  });
  next();
});

// Allow cross-origin requests
router.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

router.get('/api/express/secret', (req, res) => {
  res.json({ secret: process.env.MY_SECRET });
});

router.get('/api/express/add', (req, res) => {
  var operationResult = parseInt(req.query.num1) + parseInt(req.query.num2);
  postToBootStorage(req.query.num1, req.query.num2, "+", operationResult);
  res.json({ result: operationResult });
});

router.get('/api/express/subtract', (req, res) => {
  var operationResult = parseInt(req.query.num1) - parseInt(req.query.num2);
  postToBootStorage(req.query.num1, req.query.num2, "-", operationResult);
  res.json({ result: operationResult });
});

router.get('/api/express/healthz', (req, res) => {
  res.end();
});

// Expose /metrics endpoint for Prometheus scraping
router.get('/metrics', async (req, res) => {
  try {
    res.set('Content-Type', client.register.contentType);
    const metrics = await client.register.metrics();
    res.send(metrics);  // Send the metrics using res.send()
  } catch (err) {
    res.status(500).send(err.message);  // Return error message on failure
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

  console.log("Sending create operation request to Spring Boot service 'bootstorage'. Data = ", JSON.stringify(data));
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

module.exports = router;
