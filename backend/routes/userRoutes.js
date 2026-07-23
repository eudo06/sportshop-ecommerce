const express = require('express');
const router = express.Router();
const { getAllUsers, banUser, unbanUser } = require('../controllers/userController');
const { authenticate, authorize } = require('../middleware/auth');

router.use(authenticate);
router.use(authorize('admin'));

router.get('/', getAllUsers);
router.post('/:id/ban', banUser);
router.post('/:id/unban', unbanUser);

module.exports = router;
