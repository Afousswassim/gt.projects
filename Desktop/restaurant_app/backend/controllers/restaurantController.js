const Restaurant = require('../models/Restaurant');

exports.getAllRestaurants = async (req, res) => {
  try {
    const restaurants = await Restaurant.find({ isOpen: true })
      .sort({ rating: -1 });
    
    res.status(200).json({
      success: true,
      data: restaurants,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

exports.getRestaurantById = async (req, res) => {
  try {
    const restaurant = await Restaurant.findById(req.params.id);

    if (!restaurant) {
      return res.status(404).json({
        success: false,
        message: 'Restaurant not found',
      });
    }

    res.status(200).json({
      success: true,
      data: restaurant,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

exports.createRestaurant = async (req, res) => {
  try {
    const { name, description, imageUrl, rating, deliveryTime, deliveryFee, minOrder, cuisine } = req.body;

    const restaurant = await Restaurant.create({
      name,
      description,
      imageUrl,
      rating,
      deliveryTime,
      deliveryFee,
      minOrder,
      cuisine,
    });

    res.status(201).json({
      success: true,
      data: restaurant,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};
