// simple app which listens on port 3000 and responds with "Hello World!" to all requests use express()
const http = require('http');
const app = http();
const port = 3000;
app.get('*', (req, res) => {
  res.send('Hello World! from Docker CI/CD pipeline');
});
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
});
