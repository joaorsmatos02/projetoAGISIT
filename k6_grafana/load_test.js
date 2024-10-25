import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate } from 'k6/metrics';

// ### UNCOMMENT TO TEST WHAT YOU WANT ###
// ### RUN WITH > k6 run load_test.js

// Custom metrics for error rate
let errorRate = new Rate('errors');

// Options to control the number of virtual users (clients) and duration
export let options = {
    stages: [
        { duration: '10s', target: 200 },  // ramp-up to 200 users
        { duration: '1m', target: 200 },   // stay at 200 users
        //{ duration: '10s', target: 500 },  // ramp-up to 500 users
        //{ duration: '1m', target: 500 },   // stay at 500 users
        // { duration: '10s', target: 1000 }, // ramp-up to 1000 users
        // { duration: '1m', target: 1000 },  // stay at 1000 users
        //{ duration: '10s', target: 2500 }, // ramp-up to 2500 users
        //{ duration: '1m', target: 2500 },  // stay at 2500 users
    ],
};

// Load Balancer IP for all microservices
const BASE_URL = 'http://34.116.237.107';

export default function () {
    // Test addition from Expressed microservice
    let resAdd = http.get(`${BASE_URL}/api/express/add?num1=5&num2=10`);
    check(resAdd, {
        'Addition status is 200': (r) => r.status === 200,
        'Addition response time is < 200ms': (r) => r.timings.duration < 200,
    });
    errorRate.add(resAdd.status !== 200);
    
    // // Test multiply from Happy microservice
    // let resAdd = http.get(`${BASE_URL}/api/happy/multiply?num1=5&num2=10`);
    // check(resAdd, {
    //     'Multiply status is 200': (r) => r.status === 200,
    //     'Multiply response time is < 200ms': (r) => r.timings.duration < 200,
    // });
    // errorRate.add(resAdd.status !== 200);

    // // Test Bootstorage history retrieval operation
    // let resBootstorageHistory = http.get(`${BASE_URL}/api/bootstorage/operations`);
    // check(resBootstorageHistory, {
    //     'Bootstorage history status is 200': (r) => r.status === 200,
    //     'Bootstorage history response time is < 200ms': (r) => r.timings.duration < 200,
    // });
    // errorRate.add(resBootstorageHistory.status !== 200);

    // Simulate time between requests
    sleep(1);
}
