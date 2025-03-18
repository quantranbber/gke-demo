const express = require('express');
const app = express();
const port = 3000;

// Middleware để parse JSON (nếu cần)
app.use(express.json());

// Endpoint chính
app.get('/', (req, res) => {
  res.send('Hello, World! This is a basic Node.js Express app. 111');
});

// Endpoint health check
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    uptime: process.uptime(),
    timestamp: new Date().toISOString()
  });
});

// Khởi động server
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});