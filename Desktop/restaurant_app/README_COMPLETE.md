# Food Delivery Platform - Production Ready

A complete, scalable food delivery platform built with Flutter, Node.js/Express, and MongoDB.

## 📋 Project Overview

This is a **production-grade food delivery application** (similar to Uber Eats, Glovo) with:
- **Flutter Frontend**: Responsive UI for Mobile, Tablet, and Desktop (Web)
- **Node.js Backend**: RESTful API with Express.js
- **MongoDB**: Persistent data storage with Mongoose ODM
- **Clean Architecture**: Modular, scalable, and maintainable codebase
- **All prices in Moroccan Dirham (DH)**

## 🏗️ Project Structure

```
restaurant_app/
├── lib/                          # Flutter Frontend
│   ├── main.dart
│   ├── models/
│   │   └── models.dart          # All data models (Restaurant, MenuItem, Cart, Order)
│   ├── providers/
│   │   ├── restaurant_provider.dart
│   │   ├── cart_provider.dart
│   │   └── order_provider.dart
│   ├── services/
│   │   └── api_service.dart     # Centralized API client
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── home_screen.dart
│   │   ├── restaurant_details_screen.dart
│   │   ├── cart_screen.dart
│   │   ├── checkout_screen.dart
│   │   └── order_success_screen.dart
│   ├── widgets/
│   │   ├── restaurant_card.dart
│   │   └── category_chip.dart
│   └── utils/
│       └── helpers.dart         # Utilities, formatters, validators
│
├── backend/                       # Node.js Backend
│   ├── server.js                # Express server entry point
│   ├── package.json
│   ├── config/
│   │   └── database.js          # MongoDB connection
│   ├── models/
│   │   ├── Restaurant.js
│   │   ├── MenuItem.js
│   │   ├── Cart.js
│   │   └── Order.js
│   ├── controllers/
│   │   ├── restaurantController.js
│   │   ├── menuController.js
│   │   ├── cartController.js
│   │   └── orderController.js
│   ├── routes/
│   │   ├── restaurants.js
│   │   ├── menu.js
│   │   ├── cart.js
│   │   └── orders.js
│   ├── middleware/
│   │   └── errorHandler.js
│   ├── seed.js                  # Database seeding with sample data
│   └── .env                     # Environment variables
│
└── pubspec.yaml                 # Flutter dependencies
```

## 🚀 Getting Started

### Prerequisites
- Node.js 18+ LTS
- MongoDB (Local or Atlas)
- Flutter SDK 3.12+
- Dart 3.12+

### Backend Setup

#### 1. Install Dependencies
```bash
cd backend
npm install
```

#### 2. Configure Environment
Update `backend/.env`:
```env
MONGODB_URI=mongodb://localhost:27017/food-delivery
NODE_ENV=development
PORT=5000
```

#### 3. Seed Database
```bash
node seed.js
```

This creates:
- 6 restaurants (Moroccan, Italian, American, Japanese, Middle Eastern, Vegan)
- 30+ menu items across all restaurants
- Sample delivery data

#### 4. Start Backend Server
```bash
# Development (with auto-reload)
npm run dev

# Production
npm start
```

Server runs on: `http://localhost:5000`

### Frontend Setup

#### 1. Update API Base URL (if not localhost)
Edit `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'http://your-backend-url:5000';
```

#### 2. Get Flutter Dependencies
```bash
flutter pub get
```

#### 3. Run Application

**Mobile/Android:**
```bash
flutter run
```

**Web:**
```bash
flutter run -d chrome
```

**Desktop (Windows/macOS/Linux):**
```bash
flutter run -d windows
# or
flutter run -d macos
# or
flutter run -d linux
```

## 📱 Features

### Restaurant Management
- ✅ Browse all restaurants
- ✅ Filter by cuisine type
- ✅ Search restaurants
- ✅ View restaurant details and ratings

### Menu System
- ✅ View menu items by category
- ✅ Item details with images
- ✅ Prices in Moroccan Dirham
- ✅ Quantity selection before adding to cart

### Cart Management
- ✅ **Persistent server-side cart** (MongoDB backed)
- ✅ Add/remove items
- ✅ Update quantities
- ✅ Automatic cart restoration on app launch
- ✅ Cart clearing after order placement

### Order System
- ✅ Checkout with delivery information
- ✅ Order summary with totals
- ✅ Payment method selection (Cash/Card)
- ✅ Order confirmation with order ID
- ✅ Order status tracking

### Responsive UI
- ✅ **Mobile**: Single column, bottom-aligned buttons
- ✅ **Tablet**: 2-column grid, optimized spacing
- ✅ **Desktop/Web**: 3-column grid, sidebar support
- ✅ Material 3 design system

## 🔌 API Endpoints

### Restaurants
- `GET /restaurants` - Get all open restaurants
- `GET /restaurants/:id` - Get restaurant details

### Menu
- `GET /menu/:restaurantId` - Get menu items for restaurant
- `GET /menu/item/:id` - Get menu item details

### Cart (Session-based)
- `GET /cart?sessionId={id}` - Get cart
- `POST /cart` - Add to cart
- `PUT /cart` - Update cart item quantity
- `DELETE /cart` - Remove from cart
- `POST /cart/clear` - Clear cart

### Orders
- `POST /orders` - Create order
- `GET /orders/:id` - Get order details
- `GET /orders` - Get all orders
- `PUT /orders/:id/status` - Update order status

## 📊 Database Schema

### Restaurants
```javascript
{
  _id: ObjectId,
  name: String,
  description: String,
  imageUrl: String,
  rating: Number,
  deliveryTime: Number,
  deliveryFee: Number,
  minOrder: Number,
  cuisine: String,
  isOpen: Boolean,
  createdAt: DateTime
}
```

### Menu Items
```javascript
{
  _id: ObjectId,
  restaurantId: ObjectId (ref: Restaurant),
  name: String,
  description: String,
  price: Number (in DH),
  imageUrl: String,
  category: String,
  isAvailable: Boolean,
  rating: Number,
  createdAt: DateTime
}
```

### Cart (Session-based)
```javascript
{
  _id: ObjectId,
  sessionId: String (unique, indexed),
  items: [{
    menuItemId: ObjectId,
    quantity: Number,
    price: Number,
    name: String,
    restaurantId: ObjectId
  }],
  restaurantId: ObjectId,
  expiresAt: DateTime (7 days TTL),
  createdAt: DateTime
}
```

### Orders
```javascript
{
  _id: ObjectId,
  customerName: String,
  phone: String,
  address: String,
  email: String,
  items: [{
    menuItemId: ObjectId,
    name: String,
    quantity: Number,
    price: Number
  }],
  restaurantId: ObjectId (ref: Restaurant),
  subtotal: Number,
  deliveryFee: Number,
  totalAmount: Number,
  status: String (pending, confirmed, preparing, on-way, delivered),
  paymentMethod: String (cash, card),
  notes: String,
  estimatedDeliveryTime: Number,
  createdAt: DateTime
}
```

## 🛠️ Architecture Decisions

### Frontend (Flutter)
1. **Provider Pattern**: State management with ChangeNotifier
2. **Service Layer**: Centralized API client with error handling
3. **Responsive Design**: Breakpoints-based responsive layouts
4. **Session Management**: UUID-based unique session IDs
5. **Clean Separation**: Models, Services, Providers, Screens, Widgets

### Backend (Node.js)
1. **Express.js**: Lightweight, fast HTTP server
2. **Mongoose ODM**: Schema validation and relationships
3. **CORS Enabled**: Support for Flutter Web
4. **Clean Controllers**: Business logic separated from routes
5. **Error Handling**: Middleware-based error handling
6. **TTL Indexes**: Auto-expiring cart data (7 days)

### Database (MongoDB)
1. **Document-based**: Flexible schema design
2. **Indexes**: Performance optimization on frequently queried fields
3. **TTL Collections**: Automatic cart cleanup
4. **References**: ObjectId relationships between collections

## 💰 Currency System

All prices are in **Moroccan Dirham (DH)**:
- Sample restaurants: 15-18 DH delivery fee
- Menu items: 25-250 DH
- Formatter utility: `CurrencyFormatter.formatDH(amount)` → "95 DH"

## 🔐 Security Considerations

For production, implement:
1. **Authentication**: JWT tokens for user sessions
2. **Authorization**: Role-based access control
3. **Validation**: Input sanitization and rate limiting
4. **HTTPS**: Secure communication
5. **CORS**: Strict origin validation
6. **Database**: Connection pooling, prepared statements

## 📈 Scaling Recommendations

1. **Caching**: Redis for frequently accessed data
2. **Database**: Implement data partitioning
3. **API**: Load balancing with Nginx
4. **Storage**: Cloud storage (AWS S3) for images
5. **CDN**: Content delivery network for static assets
6. **Monitoring**: Implement logging and error tracking

## 🧪 Testing

### Backend Tests (to be added)
```bash
npm run test
```

### Flutter Tests
```bash
flutter test
```

## 📚 Dependencies

### Flutter
- `provider: ^6.1.5+1` - State management
- `http: ^1.1.0` - HTTP client
- `uuid: ^4.0.0` - Session ID generation

### Backend
- `express: ^4.18.2` - Web framework
- `mongoose: ^7.5.0` - MongoDB ODM
- `cors: ^2.8.5` - CORS middleware
- `dotenv: ^16.3.1` - Environment variables
- `helmet: ^7.0.0` - Security headers

## 🚢 Deployment

### Backend (Node.js)
1. Deploy to Heroku, Railway, or AWS EC2
2. Set MongoDB Atlas connection string
3. Configure environment variables
4. Enable CORS for production domain

### Frontend (Flutter)
1. Build: `flutter build web` or `flutter build apk`
2. Deploy web build to Vercel, Netlify, or Firebase Hosting
3. Publish APK to Google Play Store
4. Publish to App Store for iOS

## 📝 License

This is a production-ready template for educational purposes.

## 🤝 Support

For issues or improvements, refer to the inline code comments and architecture documentation.

---

**Built with ❤️ for production-grade delivery platforms**
