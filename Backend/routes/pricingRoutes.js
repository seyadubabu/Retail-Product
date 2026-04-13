const express = require('express');
const router = express.Router();
const controller = require('../controllers/pricingController');
const multer = require('multer');

const upload = multer({ dest: 'uploads/' });

router.post('/upload', upload.single('file'), controller.uploadCSV);
router.get('/', controller.getPricing);
router.put('/:id', controller.updatePricing);

module.exports = router;