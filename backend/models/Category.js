const db = require('../config/database');

class Category {
  static async findAll() {
    const [rows] = await db.execute('SELECT * FROM categories ORDER BY name');
    return rows;
  }

  static async findById(id) {
    const [rows] = await db.execute('SELECT * FROM categories WHERE id = ?', [id]);
    return rows[0];
  }
}

module.exports = Category;

