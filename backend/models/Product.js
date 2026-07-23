const db = require('../config/database');

class Product {
  static async create(productData) {
    const { name, description, price, original_price, category_id, image_url, discount_percentage, stock, available_colors, available_sizes } = productData;
    
    const [result] = await db.execute(
      `INSERT INTO products (name, description, price, original_price, category_id, image_url, discount_percentage, stock, available_colors, available_sizes) 
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [name, description, price, original_price, category_id, image_url, discount_percentage || 0, stock || 0, available_colors || null, available_sizes || null]
    );
    
    return this.findById(result.insertId);
  }

  static async findById(id) {
    const [rows] = await db.execute(
      `SELECT p.*, c.name as category_name, 
       COALESCE(AVG(r.rating), 0) as average_rating,
       COUNT(r.id) as rating_count
       FROM products p
       LEFT JOIN categories c ON p.category_id = c.id
       LEFT JOIN ratings r ON p.id = r.product_id
       WHERE p.id = ?
       GROUP BY p.id`,
      [id]
    );
    return rows[0];
  }

  static async findAll(filters = {}) {
    let query = `
      SELECT p.*, c.name as category_name,
      COALESCE(AVG(r.rating), 0) as average_rating,
      COUNT(DISTINCT r.id) as rating_count
      FROM products p
      LEFT JOIN categories c ON p.category_id = c.id
      LEFT JOIN ratings r ON p.id = r.product_id
      WHERE 1=1
    `;
    const params = [];

    if (filters.category_id) {
      query += ' AND p.category_id = ?';
      params.push(filters.category_id);
    }

    if (filters.min_price) {
      query += ' AND p.price >= ?';
      params.push(filters.min_price);
    }

    if (filters.max_price) {
      query += ' AND p.price <= ?';
      params.push(filters.max_price);
    }

    if (filters.search) {
      query += ' AND p.name LIKE ?';
      params.push(`%${filters.search}%`);
    }

    if (filters.on_sale) {
      query += ' AND p.discount_percentage > 0';
    }

    query += ' GROUP BY p.id ORDER BY p.id ASC';

    const [rows] = await db.execute(query, params);
    return rows;
  }

  static async update(id, productData) {
    const { name, description, price, original_price, category_id, image_url, discount_percentage, stock, available_colors, available_sizes } = productData;
    
    await db.execute(
      `UPDATE products 
       SET name = ?, description = ?, price = ?, original_price = ?, category_id = ?, 
           image_url = ?, discount_percentage = ?, stock = ?, available_colors = ?, available_sizes = ?
       WHERE id = ?`,
      [name, description, price, original_price, category_id, image_url, discount_percentage || 0, stock || 0, available_colors || null, available_sizes || null, id]
    );
    
    return this.findById(id);
  }

  static async delete(id) {
    await db.execute('DELETE FROM products WHERE id = ?', [id]);
    return true;
  }
}

module.exports = Product;

