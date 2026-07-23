const Cart = require('../models/Cart');

const getCart = async (req, res) => {
  try {
    const items = await Cart.getCartItems(req.user.id);
    res.json(items);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error fetching cart' });
  }
};

const addToCart = async (req, res) => {
  try {
    const { productId, quantity, selectedColor, selectedSize } = req.body;
    const items = await Cart.addToCart(req.user.id, productId, quantity || 1, selectedColor || null, selectedSize || null);
    res.json(items);
  } catch (error) {
    console.error(error);
    if (error.code === 'OUT_OF_STOCK') {
      return res.status(400).json({ message: error.message, available: error.available });
    }
    if (error.code === 'PRODUCT_NOT_FOUND') {
      return res.status(404).json({ message: 'Product not found' });
    }
    res.status(500).json({ message: 'Error adding to cart' });
  }
};

const updateCartItem = async (req, res) => {
  try {
    const { id } = req.params;
    const { quantity } = req.body;
    const items = await Cart.updateQuantity(req.user.id, id, quantity);
    res.json(items);
  } catch (error) {
    console.error(error);
    if (error.code === 'OUT_OF_STOCK') {
      return res.status(400).json({ message: error.message, available: error.available });
    }
    if (error.code === 'CART_ITEM_NOT_FOUND') {
      return res.status(404).json({ message: 'Cart item not found' });
    }
    res.status(500).json({ message: 'Error updating cart' });
  }
};

const removeFromCart = async (req, res) => {
  try {
    const { id } = req.params;
    const items = await Cart.removeFromCart(req.user.id, id);
    res.json(items);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error removing from cart' });
  }
};

const clearCart = async (req, res) => {
  try {
    await Cart.clearCart(req.user.id);
    res.json({ message: 'Cart cleared successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error clearing cart' });
  }
};

module.exports = {
  getCart,
  addToCart,
  updateCartItem,
  removeFromCart,
  clearCart
};
