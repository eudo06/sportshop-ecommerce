const db = require('../config/database');

class Rating {
  static async createOrUpdate(userId, productId, rating) {
    await db.execute(
      `INSERT INTO ratings (user_id, product_id, rating) 
       VALUES (?, ?, ?)
       ON DUPLICATE KEY UPDATE rating = ?`,
      [userId, productId, rating, rating]
    );
    return this.findByUserAndProduct(userId, productId);
  }

  static async findByUserAndProduct(userId, productId) {
    const [rows] = await db.execute(
      'SELECT * FROM ratings WHERE user_id = ? AND product_id = ?',
      [userId, productId]
    );
    return rows[0];
  }

  static async getProductRatings(productId) {
    const [rows] = await db.execute(
      `SELECT AVG(rating) as average_rating, COUNT(*) as count 
       FROM ratings WHERE product_id = ?`,
      [productId]
    );
    return rows[0];
  }
}

module.exports = Rating;
