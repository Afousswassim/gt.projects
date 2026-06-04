const Order = require('../models/Order');
const Cart = require('../models/Cart');

exports.createOrder = async (req, res) => {
  try {
    const { sessionId, customerName, phone, address, email, notes, restaurantId, deliveryFee, paymentMethod } = req.body;

    if (!sessionId || !customerName || !phone || !address || !restaurantId) {
      return res.status(400).json({
        success: false,
        message: 'Missing required fields',
      });
    }

    const cart = await Cart.findOne({ sessionId });

    if (!cart || cart.items.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Cart is empty',
      });
    }

    let subtotal = 0;
    const orderItems = cart.items.map((item) => {
      const itemTotal = item.price * item.quantity;
      subtotal += itemTotal;
      return {
        menuItemId: item.menuItemId,
        name: item.name,
        quantity: item.quantity,
        price: item.price,
      };
    });

    const totalAmount = subtotal + (deliveryFee || 15);

    const order = await Order.create({
      customerName,
      phone,
      address,
      email: email || '',
      items: orderItems,
      restaurantId,
      subtotal,
      deliveryFee: deliveryFee || 15,
      totalAmount,
      paymentMethod: paymentMethod || 'cash',
      notes: notes || '',
    });

    cart.items = [];
    await cart.save();

    res.status(201).json({
      success: true,
      data: order,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

exports.getOrder = async (req, res) => {
  try {
    const order = await Order.findById(req.params.id);

    if (!order) {
      return res.status(404).json({
        success: false,
        message: 'Order not found',
      });
    }

    res.status(200).json({
      success: true,
      data: order,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

exports.getAllOrders = async (req, res) => {
  try {
    const orders = await Order.find()
      .sort({ createdAt: -1 })
      .limit(50);

    res.status(200).json({
      success: true,
      data: orders,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

exports.updateOrderStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    if (!status) {
      return res.status(400).json({
        success: false,
        message: 'Status is required',
      });
    }

    const order = await Order.findByIdAndUpdate(
      id,
      { status },
      { new: true }
    );

    if (!order) {
      return res.status(404).json({
        success: false,
        message: 'Order not found',
      });
    }

    res.status(200).json({
      success: true,
      data: order,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};
