const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const connectDB = require('./config/db');
const userRoutes = require('./routes/users');

dotenv.config();

// Connect to MongoDB
connectDB();

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

// Routes
app.use('/api/users', userRoutes);
app.use('/api/data', require('./routes/data'));

app.get('/', (req, res) => {
    res.send('Currency Converter Admin API is running');
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
