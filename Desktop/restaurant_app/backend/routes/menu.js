const express = require('express');
const menuController = require('../controllers/menuController');

const router = express.Router();

router.get('/:restaurantId', menuController.getMenuByRestaurant);
router.get('/item/:id', menuController.getMenuItemById);
router.post('/', menuController.createMenuItem);

module.exports = router;
