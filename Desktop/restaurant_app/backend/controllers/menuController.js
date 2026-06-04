const MenuItem = require('../models/MenuItem');

exports.getMenuByRestaurant = async (req, res) => {
  try {
    const { restaurantId } = req.params;

    const items = await MenuItem.find({ restaurantId })
      .sort({ category: 1, name: 1 });

    res.status(200).json({
      success: true,
      data: items,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

exports.getMenuItemById = async (req, res) => {
  try {
    const item = await MenuItem.findById(req.params.id);

    if (!item) {
      return res.status(404).json({
        success: false,
        message: 'Menu item not found',
      });
    }

    res.status(200).json({
      success: true,
      data: item,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

exports.createMenuItem = async (req, res) => {
  try {
    const { restaurantId, name, description, price, imageUrl, category } = req.body;

    const item = await MenuItem.create({
      restaurantId,
      name,
      description,
      price,
      imageUrl,
      category,
    });

    res.status(201).json({
      success: true,
      data: item,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};
