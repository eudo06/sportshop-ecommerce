const db = require('../config/database');
const bcrypt = require('bcryptjs');

class User {
  static async create(userData) {
    const { nickname, email, password } = userData;
    const hashedPassword = await bcrypt.hash(password, 10);
    
    const [result] = await db.execute(
      'INSERT INTO users (nickname, email, password) VALUES (?, ?, ?)',
      [nickname, email, hashedPassword]
    );
    
    return this.findById(result.insertId);
  }

  static async findById(id) {
    const [rows] = await db.execute(
      'SELECT id, nickname, email, role, is_banned, created_at FROM users WHERE id = ?',
      [id]
    );
    return rows[0];
  }

  static async findByEmail(email) {
    const [rows] = await db.execute(
      'SELECT * FROM users WHERE email = ?',
      [email]
    );
    return rows[0];
  }

  static async verifyPassword(plainPassword, hashedPassword) {
    return await bcrypt.compare(plainPassword, hashedPassword);
  }

  static async getAll() {
    const [rows] = await db.execute(
      'SELECT id, nickname, email, role, is_banned, created_at FROM users ORDER BY created_at DESC'
    );
    return rows;
  }

  static async banUser(userId) {
    await db.execute(
      'UPDATE users SET is_banned = TRUE WHERE id = ?',
      [userId]
    );
    return this.findById(userId);
  }

  static async unbanUser(userId) {
    await db.execute(
      'UPDATE users SET is_banned = FALSE WHERE id = ?',
      [userId]
    );
    return this.findById(userId);
  }
}

module.exports = User;

