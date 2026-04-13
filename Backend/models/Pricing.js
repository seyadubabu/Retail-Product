const mongoose = require('mongoose');

const PricingSchema = new mongoose.Schema({
  storeId: { type: String, index: true },
  sku: { type: String, index: true },
  productName: String,
  price: Number,
  date: { type: Date, index: true }
}, { timestamps: true });

module.exports = mongoose.model('Pricing', PricingSchema);