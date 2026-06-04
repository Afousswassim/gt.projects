const Cart = require('../models/Cart');
const MenuItem = require('../models/MenuItem');

exports.getCart = async (req, res) => {
  try {
    const { sessionId } = req.query;

    if (!sessionId) {
      return res.status(400).json({
        success: false,
        message: 'Session ID is required',
      });
    }

    let cart = await Cart.findOne({ sessionId });

    if (!cart) {
      cart = await Cart.create({
        sessionId,
        items: [],
      });
    }

    res.status(200).json({
      success: true,
      data: cart,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

exports.addToCart = async (req, res) => {
  try {
    const { sessionId, menuItemId, quantity, restaurantId } = req.body;

    if (!sessionId || !menuItemId || !quantity || !restaurantId) {
      return res.status(400).json({
        success: false,
        message: 'Missing required fields',
      });
    }

    const menuItem = await MenuItem.findById(menuItemId);
    if (!menuItem) {
      return res.status(404).json({
        success: false,
        message: 'Menu item not found',
      });
    }

    let cart = await Cart.findOne({ sessionId });

    if (!cart) {
      cart = await Cart.create({
        sessionId,
        restaurantId,
        items: [],
      });
    }

    if (cart.restaurantId && cart.restaurantId.toString() !== restaurantId) {
      cart.items = [];
      cart.restaurantId = restaurantId;
    } else {
      cart.restaurantId = restaurantId;
    }

    const existingItem = cart.items.find(
      (item) => item.menuItemId.toString() === menuItemId
    );

    if (existingItem) {
      existingItem.quantity += quantity;
    } else {
      cart.items.push({
        menuItemId,
        quantity,
        price: menuItem.price,
        name: menuItem.name,
        restaurantId,
      });
    }

    await cart.save();

    res.status(200).json({
      success: true,
      data: cart,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

exports.updateCartItem = async (req, res) => {
  try {
    const { sessionId, menuItemId, quantity } = req.body;

    if (!sessionId || !menuItemId) {
      return res.status(400).json({
        success: false,
        message: 'Missing required fields',
      });
    }

    const cart = await Cart.findOne({ sessionId });

    if (!cart) {
      return res.status(404).json({
        success: false,
        message: 'Cart not found',
      });
    }

    const item = cart.items.find(
      (item) => item.menuItemId.toString() === menuItemId
    );

    if (!item) {
      return res.status(404).json({
        success: false,
        message: 'Item not in cart',
      });
    }

    if (quantity <= 0) {
      cart.items = cart.items.filter(
        (item) => item.menuItemId.toString() !== menuItemId
      );
    } else {
      item.quantity = quantity;
    }

    await cart.save();

    res.status(200).json({
      success: true,
      data: cart,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

exports.removeFromCart = async (req, res) => {
  try {
    const { sessionId, menuItemId } = req.body;

    if (!sessionId || !menuItemId) {
      return res.status(400).json({
        success: false,
        message: 'Missing required fields',
      });
    }

    const cart = await Cart.findOne({ sessionId });

    if (!cart) {
      return res.status(404).json({
        success: false,
        message: 'Cart not found',
      });
    }

    cart.items = cart.items.filter(
      (item) => item.menuItemId.toString() !== menuItemId
    );

    await cart.save();

    res.status(200).json({
      success: true,
      data: cart,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

exports.clearCart = async (req, res) => {
  try {
    const { sessionId } = req.body;

    if (!sessionId) {
      return res.status(400).json({
        success: false,
        message: 'Session ID is required',
      });
    }

    const cart = await Cart.findOne({ sessionId });

    if (!cart) {
      return res.status(404).json({
        success: false,
        message: 'Cart not found',
      });
    }

    cart.items = [];
    await cart.save();

    res.status(200).json({
      success: true,
      data: cart,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};
