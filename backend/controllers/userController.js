const User = require('../models/User');

const getAllUsers = async (req, res) => {
  try {
    const users = await User.getAll();
    res.json(users);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error fetching users' });
  }
};

const banUser = async (req, res) => {
  try {
    const user = await User.banUser(req.params.id);
    res.json({ message: 'User banned successfully', user });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error banning user' });
  }
};

const unbanUser = async (req, res) => {
  try {
    const user = await User.unbanUser(req.params.id);
    res.json({ message: 'User unbanned successfully', user });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error unbanning user' });
  }
};

module.exports = {
  getAllUsers,
  banUser,
  unbanUser
};
