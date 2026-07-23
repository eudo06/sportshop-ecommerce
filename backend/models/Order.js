const db = require('../config/database');

class Order {
  static async create(userId, cartItems) {
    const connection = await db.getConnection();
    
    try {
      await connection.beginTransaction();

      for (const item of cartItems) {
        const productId = item.product_id;
        const requestedQty = parseInt(item.quantity, 10);

        const [rows] = await connection.execute(
          'SELECT id, name, stock FROM products WHERE id = ? FOR UPDATE',
          [productId]
        );

        if (rows.length === 0) {
          const error = new Error(`Product not found (id=${productId})`);
          error.code = 'PRODUCT_NOT_FOUND';
          throw error;
        }

        const product = rows[0];

        if (requestedQty > product.stock) {
          const error = new Error(
            `Insufficient stock for product "${product.name}". Requested ${requestedQty}, available ${product.stock}.`
          );
          error.code = 'OUT_OF_STOCK';
          error.productId = product.id;
          throw error;
        }
      }

      const totalAmount = cartItems.reduce((total, item) => {
        return total + parseFloat(item.price) * parseInt(item.quantity, 10);
      }, 0);

      const [orderResult] = await connection.execute(
        'INSERT INTO orders (user_id, total_amount, status) VALUES (?, ?, ?)',
        [userId, totalAmount, 'pending']
      );

      const orderId = orderResult.insertId;

      for (const item of cartItems) {
        const productId = item.product_id;
        const qty = parseInt(item.quantity, 10);

        await connection.execute(
          'INSERT INTO order_items (order_id, product_id, quantity, price, selected_color, selected_size) VALUES (?, ?, ?, ?, ?, ?)',
          [orderId, productId, qty, item.price, item.selected_color || null, item.selected_size || null]
        );

        await connection.execute(
          'UPDATE products SET stock = stock - ? WHERE id = ?',
          [qty, productId]
        );
      }

      await connection.execute(
        'DELETE FROM cart_items WHERE user_id = ?',
        [userId]
      );

      await connection.commit();

      return this.findById(orderId);
    } catch (error) {
      await connection.rollback();
      throw error;
    } finally {
      connection.release();
    }
  }

  static async findById(id) {
    const [orderRows] = await db.execute(
      'SELECT * FROM orders WHERE id = ?',
      [id]
    );
    
    if (orderRows.length === 0) {
      return null;
    }

    const [itemRows] = await db.execute(
      `SELECT oi.*, p.name, p.image_url 
       FROM order_items oi
       JOIN products p ON oi.product_id = p.id
       WHERE oi.order_id = ?`,
      [id]
    );

    return {
      ...orderRows[0],
      items: itemRows
    };
  }

  static async findByUser(userId) {
    const [rows] = await db.execute(
      `SELECT o.*, 
       COUNT(oi.id) as item_count
       FROM orders o
       LEFT JOIN order_items oi ON o.id = oi.order_id
       WHERE o.user_id = ?
       GROUP BY o.id
       ORDER BY o.created_at DESC`,
      [userId]
    );
    return rows;
  }
}

module.exports = Order;
