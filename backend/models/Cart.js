const db = require('../config/database');

class Cart {
  static async getCartItems(userId) {
    const [rows] = await db.execute(
      `SELECT ci.*, p.name, p.price, p.image_url, p.discount_percentage, p.original_price, p.available_colors, p.available_sizes
       FROM cart_items ci
       JOIN products p ON ci.product_id = p.id
       WHERE ci.user_id = ?`,
      [userId]
    );
    return rows;
  }



  static async addToCart(userId, productId, quantity = 1, selectedColor = null, selectedSize = null) {
    const [[product]] = await db.execute(
      'SELECT id, name, stock FROM products WHERE id = ?',
      [productId]
    );

    if (!product) {
      const error = new Error('Product not found');
      error.code = 'PRODUCT_NOT_FOUND';
      throw error;
    }

    const [existing] = await db.execute(
      'SELECT * FROM cart_items WHERE user_id = ? AND product_id = ? AND (selected_color = ? OR (selected_color IS NULL AND ? IS NULL)) AND (selected_size = ? OR (selected_size IS NULL AND ? IS NULL))',
      [userId, productId, selectedColor, selectedColor, selectedSize, selectedSize]
    );

    const currentQty = existing.length > 0 ? parseInt(existing[0].quantity, 10) : 0;
    const requestedQty = currentQty + parseInt(quantity, 10);

    if (requestedQty > product.stock) {
      const error = new Error(`Only ${product.stock} unit(s) of "${product.name}" available`);
      error.code = 'OUT_OF_STOCK';
      error.available = product.stock;
      throw error;
    }

    if (existing.length > 0) {
      await db.execute(
        'UPDATE cart_items SET quantity = quantity + ? WHERE user_id = ? AND product_id = ? AND (selected_color = ? OR (selected_color IS NULL AND ? IS NULL)) AND (selected_size = ? OR (selected_size IS NULL AND ? IS NULL))',
        [quantity, userId, productId, selectedColor, selectedColor, selectedSize, selectedSize]
      );
    } else {
      await db.execute(
        'INSERT INTO cart_items (user_id, product_id, quantity, selected_color, selected_size) VALUES (?, ?, ?, ?, ?)',
        [userId, productId, quantity, selectedColor, selectedSize]
      );
    }

    return this.getCartItems(userId);
  }




  static async updateQuantity(userId, cartItemId, quantity) {
    const [[item]] = await db.execute(
      `SELECT ci.product_id, ci.quantity, p.stock, p.name
       FROM cart_items ci
       JOIN products p ON ci.product_id = p.id
       WHERE ci.id = ? AND ci.user_id = ?`,
      [cartItemId, userId]
    );

    if (!item) {
      const error = new Error('Cart item not found');
      error.code = 'CART_ITEM_NOT_FOUND';
      throw error;
    }

    if (quantity <= 0) {
      await db.execute(
        'DELETE FROM cart_items WHERE id = ? AND user_id = ?',
        [cartItemId, userId]
      );
    } else {
      if (quantity > item.stock) {
        const error = new Error(`Only ${item.stock} unit(s) of "${item.name}" available`);
        error.code = 'OUT_OF_STOCK';
        error.available = item.stock;
        throw error;
      }

      await db.execute(
        'UPDATE cart_items SET quantity = ? WHERE id = ? AND user_id = ?',
        [quantity, cartItemId, userId]
      );
    }
    return this.getCartItems(userId);
  }

  static async removeFromCart(userId, cartItemId) {
    await db.execute(
      'DELETE FROM cart_items WHERE id = ? AND user_id = ?',
      [cartItemId, userId]
    );
    return this.getCartItems(userId);
  }

  static async clearCart(userId) {
    await db.execute('DELETE FROM cart_items WHERE user_id = ?', [userId]);
    return true;
  }
}

module.exports = Cart;
