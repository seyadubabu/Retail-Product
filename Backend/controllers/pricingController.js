const fs = require('fs');
const csv = require('csv-parser');
const Pricing = require('../models/Pricing');

exports.uploadCSV = async (req, res) => {
  const results = [];

  fs.createReadStream(req.file.path)
    .pipe(csv())
    .on('data', (data) => {
      results.push({
        storeId: data['StoreID'],
        sku: data['SKU'],
        productName: data['ProductName'],
        price: parseFloat(data['Price']),
        date: new Date(data['Date'])
      });
    })
    .on('end', async () => {
      await Pricing.insertMany(results);
      res.json({ message: 'Upload successful', count: results.length });
    });
};

exports.getPricing = async (req, res) => {
  const { storeId, sku, page = 1, limit = 20 } = req.query;

  const query = {};
  if (storeId) query.storeId = storeId;
  if (sku) query.sku = sku;

  const data = await Pricing.find(query)
    .skip((page - 1) * limit)
    .limit(parseInt(limit));

  res.json(data);
};

exports.updatePricing = async (req, res) => {
  const updated = await Pricing.findByIdAndUpdate(req.params.id, req.body, { new: true });
  res.json(updated);
};