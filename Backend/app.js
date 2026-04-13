const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const pricingRoutes = require('./routes/pricingRoutes');

const app = express();
app.use(cors());
app.use(express.json());

mongoose.connect('mongodb://127.0.0.1:27017/pricing_db');

app.use('/api/pricing', pricingRoutes);

app.listen(3000, () => console.log('✅ Server running on port 3000'));