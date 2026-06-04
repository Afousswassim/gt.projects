const express = require('express');
const orderController = require('../controllers/orderController');

const router = express.Router();

router.post('/', orderController.createOrder);
router.get('/:id', orderController.getOrder);
router.get('/', orderController.getAllOrders);
router.put('/:id/status', orderController.updateOrderStatus);

module.exports = router;
