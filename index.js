// Simple HTTP server that listens on port 3000 and responds with "Hello World!"
const http = require('http');
const port = 3000;
const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('Hello World! from Docker CI/CD pipeline');
});
server.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
});
