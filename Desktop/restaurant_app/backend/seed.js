require('dotenv').config();
const mongoose = require('mongoose');
const Restaurant = require('./models/Restaurant');
const MenuItem = require('./models/MenuItem');

const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/food-delivery';

const seedDatabase = async () => {
  try {
    await mongoose.connect(MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });

    console.log('Connected to MongoDB');

    // Clear existing data
    await Restaurant.deleteMany({});
    await MenuItem.deleteMany({});

    // Create restaurants
    const restaurants = await Restaurant.create([
      {
        name: 'La Médina Grill',
        description: 'Traditional Moroccan grilled specialties and tajines',
        imageUrl: 'https://images.unsplash.com/photo-1604482046058-e906169e6b7c?w=400&h=250&fit=crop',
        rating: 4.8,
        deliveryTime: 30,
        deliveryFee: 15,
        minOrder: 50,
        cuisine: 'Moroccan',
        isOpen: true,
      },
      {
        name: 'Pizza Paradise',
        description: 'Authentic Italian pizzas and pastas',
        imageUrl: 'https://images.unsplash.com/photo-1514432324607-2e467f4af445?w=400&h=250&fit=crop',
        rating: 4.6,
        deliveryTime: 25,
        deliveryFee: 12,
        minOrder: 40,
        cuisine: 'Italian',
        isOpen: true,
      },
      {
        name: 'Burger Bazaar',
        description: 'Juicy burgers and crispy fries',
        imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=250&fit=crop',
        rating: 4.5,
        deliveryTime: 20,
        deliveryFee: 10,
        minOrder: 35,
        cuisine: 'American',
        isOpen: true,
      },
      {
        name: 'Sushi Master',
        description: 'Premium sushi and Japanese cuisine',
        imageUrl: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400&h=250&fit=crop',
        rating: 4.7,
        deliveryTime: 35,
        deliveryFee: 18,
        minOrder: 80,
        cuisine: 'Japanese',
        isOpen: true,
      },
      {
        name: 'Kebab House',
        description: 'Delicious shawarmas and kebabs',
        imageUrl: 'https://images.unsplash.com/photo-1529621686055-5cafc0e0b1a5?w=400&h=250&fit=crop',
        rating: 4.4,
        deliveryTime: 25,
        deliveryFee: 12,
        minOrder: 30,
        cuisine: 'Middle Eastern',
        isOpen: true,
      },
      {
        name: 'Vegan Heaven',
        description: 'Healthy vegan bowls and smoothies',
        imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&h=250&fit=crop',
        rating: 4.3,
        deliveryTime: 20,
        deliveryFee: 10,
        minOrder: 40,
        cuisine: 'Vegan',
        isOpen: true,
      },
    ]);

    console.log('✅ Restaurants created');

    // Create menu items for each restaurant
    const menuData = [
      // La Médina Grill
      {
        restaurantId: restaurants[0]._id,
        items: [
          { name: 'Tajine Chicken', description: 'Slow-cooked chicken with preserved lemons and olives', price: 95, category: 'Main Course', imageUrl: 'https://images.unsplash.com/photo-1504674900152-b8b80e7dba3f?w=300&h=200&fit=crop' },
          { name: 'Lamb Kebab', description: 'Grilled lamb kebab with spices', price: 120, category: 'Main Course', imageUrl: 'https://images.unsplash.com/photo-1519921866021-92bcf56d4ff7?w=300&h=200&fit=crop' },
          { name: 'Moroccan Salad', description: 'Fresh tomato and cucumber salad', price: 35, category: 'Salads', imageUrl: 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=300&h=200&fit=crop' },
          { name: 'Harira Soup', description: 'Traditional Moroccan soup', price: 28, category: 'Soups', imageUrl: 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=300&h=200&fit=crop' },
          { name: 'Couscous Royal', description: 'Couscous with meat and vegetables', price: 110, category: 'Main Course', imageUrl: 'https://images.unsplash.com/photo-1563737404-beeb1b4d227f?w=300&h=200&fit=crop' },
        ],
      },
      // Pizza Paradise
      {
        restaurantId: restaurants[1]._id,
        items: [
          { name: 'Margherita Pizza', description: 'Fresh mozzarella, tomato, basil', price: 85, category: 'Pizzas', imageUrl: 'https://images.unsplash.com/photo-1604068549290-dea0e4a305ca?w=300&h=200&fit=crop' },
          { name: 'Pepperoni Pizza', description: 'Loaded with pepperoni slices', price: 95, category: 'Pizzas', imageUrl: 'https://images.unsplash.com/photo-1614049162883-56ceaca32113?w=300&h=200&fit=crop' },
          { name: 'Pasta Carbonara', description: 'Classic Roman pasta', price: 75, category: 'Pasta', imageUrl: 'https://images.unsplash.com/photo-1612874742237-6526221fcf4f?w=300&h=200&fit=crop' },
          { name: 'Caesar Salad', description: 'Romaine, parmesan, croutons', price: 45, category: 'Salads', imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300&h=200&fit=crop' },
          { name: 'Tiramisu', description: 'Italian dessert classic', price: 35, category: 'Desserts', imageUrl: 'https://images.unsplash.com/photo-1571115177098-24ec42ed204d?w=300&h=200&fit=crop' },
        ],
      },
      // Burger Bazaar
      {
        restaurantId: restaurants[2]._id,
        items: [
          { name: 'Classic Burger', description: 'Beef patty, lettuce, tomato, cheese', price: 65, category: 'Burgers', imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300&h=200&fit=crop' },
          { name: 'Double Burger', description: 'Two beef patties with all toppings', price: 85, category: 'Burgers', imageUrl: 'https://images.unsplash.com/photo-1550547990-a82a1c068d7f?w=300&h=200&fit=crop' },
          { name: 'Crispy Fries', description: 'Golden crispy french fries', price: 25, category: 'Sides', imageUrl: 'https://images.unsplash.com/photo-1585238341710-4911667b0fbf?w=300&h=200&fit=crop' },
          { name: 'Chicken Burger', description: 'Crispy fried chicken breast', price: 75, category: 'Burgers', imageUrl: 'https://images.unsplash.com/photo-1585525046569-c0e90a1c6fae?w=300&h=200&fit=crop' },
          { name: 'Milkshake', description: 'Vanilla, chocolate, or strawberry', price: 30, category: 'Drinks', imageUrl: 'https://images.unsplash.com/photo-1585238341710-4911667b0fbf?w=300&h=200&fit=crop' },
        ],
      },
      // Sushi Master
      {
        restaurantId: restaurants[3]._id,
        items: [
          { name: 'Salmon Roll', description: 'Fresh salmon sushi roll', price: 110, category: 'Sushi', imageUrl: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=300&h=200&fit=crop' },
          { name: 'Tuna Nigiri', description: 'Premium tuna nigiri (6 pieces)', price: 95, category: 'Sushi', imageUrl: 'https://images.unsplash.com/photo-1553621042-f6e147245754?w=300&h=200&fit=crop' },
          { name: 'Vegetable Roll', description: 'Cucumber, avocado, carrot', price: 55, category: 'Sushi', imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300&h=200&fit=crop' },
          { name: 'Edamame', description: 'Steamed soybeans with salt', price: 35, category: 'Appetizers', imageUrl: 'https://images.unsplash.com/photo-1599599810694-b5ac4dd26f1a?w=300&h=200&fit=crop' },
          { name: 'Miso Soup', description: 'Traditional miso broth', price: 25, category: 'Soups', imageUrl: 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=300&h=200&fit=crop' },
        ],
      },
      // Kebab House
      {
        restaurantId: restaurants[4]._id,
        items: [
          { name: 'Chicken Shawarma', description: 'Spiced chicken in pita bread', price: 45, category: 'Shawarmas', imageUrl: 'https://images.unsplash.com/photo-1529621686055-5cafc0e0b1a5?w=300&h=200&fit=crop' },
          { name: 'Lamb Shawarma', description: 'Tender lamb shawarma', price: 55, category: 'Shawarmas', imageUrl: 'https://images.unsplash.com/photo-1599599810694-b5ac4dd26f1a?w=300&h=200&fit=crop' },
          { name: 'Meat Kebab', description: 'Grilled mixed meat skewer', price: 75, category: 'Kebabs', imageUrl: 'https://images.unsplash.com/photo-1519921866021-92bcf56d4ff7?w=300&h=200&fit=crop' },
          { name: 'Hummus', description: 'Chickpea dip with tahini', price: 25, category: 'Appetizers', imageUrl: 'https://images.unsplash.com/photo-1599599810694-b5ac4dd26f1a?w=300&h=200&fit=crop' },
          { name: 'Baklava', description: 'Sweet phyllo pastry with nuts', price: 30, category: 'Desserts', imageUrl: 'https://images.unsplash.com/photo-1571115177098-24ec42ed204d?w=300&h=200&fit=crop' },
        ],
      },
      // Vegan Heaven
      {
        restaurantId: restaurants[5]._id,
        items: [
          { name: 'Buddha Bowl', description: 'Quinoa, veggies, tahini dressing', price: 65, category: 'Bowls', imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300&h=200&fit=crop' },
          { name: 'Smoothie Bowl', description: 'Acai berry with granola', price: 50, category: 'Bowls', imageUrl: 'https://images.unsplash.com/photo-1590779033100-9f60a05a2000?w=300&h=200&fit=crop' },
          { name: 'Green Salad', description: 'Fresh greens with vinaigrette', price: 40, category: 'Salads', imageUrl: 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=300&h=200&fit=crop' },
          { name: 'Veggie Burger', description: 'Plant-based patty', price: 60, category: 'Burgers', imageUrl: 'https://images.unsplash.com/photo-1585238341710-4911667b0fbf?w=300&h=200&fit=crop' },
          { name: 'Matcha Latte', description: 'Green tea latte', price: 35, category: 'Drinks', imageUrl: 'https://images.unsplash.com/photo-1571115177098-24ec42ed204d?w=300&h=200&fit=crop' },
        ],
      },
    ];

    for (const restaurant of menuData) {
      await MenuItem.create(
        restaurant.items.map((item) => ({
          ...item,
        }))
      );
    }

    console.log('✅ Menu items created');

    await mongoose.connection.close();
    console.log('✅ Database seeding completed successfully');
    process.exit(0);
  } catch (error) {
    console.error('❌ Error seeding database:', error.message);
    process.exit(1);
  }
};

seedDatabase();
