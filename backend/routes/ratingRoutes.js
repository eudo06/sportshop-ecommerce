const express = require('express');
const router = express.Router();
const { rateProduct, getUserRating } = require('../controllers/ratingController');
const { authenticate } = require('../middleware/auth');

router.use(authenticate);

router.post('/:productId', rateProduct);
router.get('/:productId', getUserRating);

module.exports = router;

