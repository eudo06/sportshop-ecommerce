const Rating = require('../models/Rating');

const rateProduct = async (req, res) => {
  try {
    const { productId } = req.params;
    const { rating } = req.body;

    if (!rating || rating < 1 || rating > 5) {
      return res.status(400).json({ message: 'Rating must be between 1 and 5' });
    }

    const result = await Rating.createOrUpdate(req.user.id, productId, rating);
    res.json({ message: 'Product rated successfully', rating: result });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error rating product' });
  }
};

const getUserRating = async (req, res) => {
  try {
    const { productId } = req.params;
    const rating = await Rating.findByUserAndProduct(req.user.id, productId);
    res.json(rating || { rating: 0 });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error fetching rating' });
  }
};

module.exports = {
  rateProduct,
  getUserRating
};

