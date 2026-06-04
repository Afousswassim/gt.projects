# Food Delivery App - Setup & Troubleshooting Guide

## Fix: "Error: Exception: Network Error: Failed to fetch"

This error occurs when the Flutter app cannot connect to the Node.js backend API.

### Solution 1: Ensure Backend is Running

**Step 1: Install Dependencies**
```bash
cd backend
npm install
```

**Step 2: Start MongoDB**

On Windows (using MongoDB Community):
```bash
"C:\Program Files\MongoDB\Server\6.0\bin\mongod.exe"
```

Or using MongoDB Atlas (cloud database):
- Replace `MONGODB_URI` in `.env` with your Atlas connection string

**Step 3: Seed Database**
```bash
cd backend
node seed.js
```

Expected output:
```
✅ Restaurants created
✅ Menu items created
✅ Database seeding completed successfully
```

**Step 4: Start Backend Server**
```bash
npm run dev
```

Expected output:
```
🚀 Food Delivery Backend running on http://localhost:5000
```

### Solution 2: Fix Network Configuration in Flutter

**For Web/Desktop:**
- Backend URL is correct: `http://localhost:5000`

**For Android Emulator:**
- Change API URL to: `http://10.0.2.2:5000`
- Edit: `lib/services/api_service.dart`

**For Mobile Testing (Real Device):**
- Find your computer's IP: `ipconfig` (Windows) or `ifconfig` (Mac/Linux)
- Change API URL to: `http://192.168.X.X:5000`

### Solution 3: Check CORS Configuration

Backend (`backend/server.js`) has CORS enabled:
```javascript
app.use(cors({
  origin: ['http://localhost:3000', 'http://localhost:8080', '*'],
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  credentials: true,
}));
```

If still having issues, make sure Node.js has network access.

---

## Image Display Issues

### All images are valid Unsplash URLs:
- Valid format: `https://images.unsplash.com/...`
- All menu items have fallback images
- Images load with proper error handling

### If images still don't load:

1. **Check Internet Connection** - Required for external images
2. **Local Fallback** - App uses dummy data with valid images if API fails
3. **Image Format** - All images are JPG/PNG, properly sized

---

## Price Display

All prices display in Moroccan Dirham format:
```
"35 DH"
"85 DH"
"120 DH"
```

This is enforced by `CurrencyFormatter.formatDH()` in all UI components.

---

## Database Structure

After seeding, database contains:
- **6 Restaurants** (Moroccan, Italian, American, Japanese, Middle Eastern, Vegan)
- **30+ Menu Items** with images, prices, and descriptions
- **Indexes** on `restaurantId` and `_id` for fast queries

---

## Complete Startup Sequence

```bash
# Terminal 1: MongoDB
mongod

# Terminal 2: Backend
cd backend
npm install
node seed.js
npm run dev

# Terminal 3: Flutter (Web)
flutter run -d chrome

# Or Mobile
flutter run -d <device_id>
```

---

## Verify Setup

Test API endpoints:
```bash
# GET all restaurants
curl http://localhost:5000/restaurants

# GET menu for restaurant 1
curl http://localhost:5000/menu/r1

# GET health check
curl http://localhost:5000/health
```

All should return:
```json
{
  "success": true,
  "data": [...]
}
```

---

## Fallback Behavior

If API fails:
✅ Restaurant list shows dummy data (4 restaurants)
✅ Menu displays fallback items with valid images
✅ Prices always in DH format
✅ No crashes - graceful error handling

---

## Performance

- **Image Loading**: Uses Unsplash CDN (fast)
- **Database Queries**: Indexed for speed
- **API Timeout**: 30 seconds
- **Fallback Data**: Loaded from local app

All images are optimized (~100-300KB each).
