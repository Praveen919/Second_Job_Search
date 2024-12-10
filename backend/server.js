const express = require('express');
const bodyParser = require('body-parser');
const dotenv = require('dotenv');
const connectDB = require('./config/dbConfig');
const userRoutes = require('./routes/userRoutes');

dotenv.config();
connectDB();

const app = express();
app.use(bodyParser.json()); // Parse JSON bodies
app.use('/api/users', userRoutes); // User routes

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server running on http:localhost:${PORT}`);
});
