# Food Delivery Platform - Quick Start Guide

## ⚡ 5-Minute Setup

### Step 1: Start MongoDB
Make sure MongoDB is running locally or use MongoDB Atlas connection string.

```bash
# If local MongoDB is installed:
mongod
```

### Step 2: Backend Setup
```bash
cd backend
npm install
node seed.js        # Seeds database with sample data
npm run dev         # Starts at http://localhost:5000
```

### Step 3: Flutter Setup
```bash
# In root directory
flutter pub get
flutter run         # Run on default device
```

## 🌐 Quick URLs

- **Backend API**: `http://localhost:5000`
- **Health Check**: `http://localhost:5000/health`
- **API Docs**: See `backend/routes/` for all endpoints

## 📱 Run on Different Devices

```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device_id>

# Web
flutter run -d chrome

# Windows Desktop
flutter run -d windows
```

## 🔧 Development Commands

### Backend
```bash
npm start           # Production mode
npm run dev         # Development with auto-reload
node seed.js        # Reseed database
```

### Frontend
```bash
flutter pub get             # Update dependencies
flutter clean              # Clean build
flutter run                # Run on device
flutter build web          # Build for web
flutter build apk          # Build Android APK
flutter format lib/        # Format code
flutter analyze            # Check for issues
```

## 📲 Testing the App

1. **Open App** → Splash screen loads
2. **Auto-initialize** → Restaurants loaded from backend
3. **Browse** → Tap on restaurant cards
4. **Add Items** → Adjust quantity and add to cart
5. **Checkout** → Fill delivery info
6. **Order** → Confirm and get order ID

## 🐛 Troubleshooting

### MongoDB Connection Error
```bash
# Check if MongoDB is running
mongosh  # or mongo (older versions)

# If not installed, use MongoDB Atlas:
# 1. Create account at mongodb.com/cloud
# 2. Update .env: MONGODB_URI=mongodb+srv://...
```

### Flutter Build Errors
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

### Backend Port Already in Use
```bash
# Change port in .env or backend/server.js
# Or kill process using port 5000
# Windows: netstat -ano | findstr :5000
# Linux/Mac: lsof -i :5000
```

### CORS Issues
- Ensure backend has CORS enabled (already configured)
- Check API base URL in `lib/services/api_service.dart`

## 📊 API Testing

### Using curl
```bash
# Get all restaurants
curl http://localhost:5000/restaurants

# Get restaurant menu
curl http://localhost:5000/menu/RESTAURANT_ID

# Check health
curl http://localhost:5000/health
```

## 🎯 Next Steps for Production

1. **Authentication**: Add user login/signup
2. **Payments**: Integrate payment gateway (Stripe, etc.)
3. **Real-time Updates**: Add WebSocket for order tracking
4. **Image Upload**: Implement restaurant/item image uploads
5. **Admin Panel**: Build restaurant management dashboard
6. **Push Notifications**: Add Firebase Cloud Messaging
7. **Analytics**: Track user behavior and orders

## 📞 API Documentation

See detailed API docs in [README_COMPLETE.md](./README_COMPLETE.md)

---

**Ready to launch! 🚀**
