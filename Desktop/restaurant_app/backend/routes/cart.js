const express = require('express');
const cartController = require('../controllers/cartController');

const router = express.Router();

router.get('/', cartController.getCart);
router.post('/', cartController.addToCart);
router.put('/', cartController.updateCartItem);
router.delete('/', cartController.removeFromCart);
router.post('/clear', cartController.clearCart);

module.exports = router;
