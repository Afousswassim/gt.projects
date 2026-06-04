# Architecture Overview

## 🎯 System Design

```
┌─────────────────────────────────────────────────────────────┐
│                      Flutter Frontend                       │
│  (Mobile, Tablet, Web - Single Codebase)                   │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Screens Layer                                              │
│  ├─ SplashScreen (Initialize App)                          │
│  ├─ HomeScreen (Browse Restaurants)                        │
│  ├─ RestaurantDetailsScreen (View Menu)                    │
│  ├─ CartScreen (Manage Cart)                               │
│  ├─ CheckoutScreen (Place Order)                           │
│  └─ OrderSuccessScreen (Confirmation)                      │
│                                                              │
│  Providers (State Management)                              │
│  ├─ RestaurantProvider (Restaurant data)                   │
│  ├─ CartProvider (Cart operations)                         │
│  └─ OrderProvider (Order management)                       │
│                                                              │
│  Services Layer                                             │
│  └─ ApiService (Centralized HTTP client)                   │
│                                                              │
└────────────────────┬────────────────────────────────────────┘
                     │ HTTP REST API
                     │ (JSON)
                     ▼
┌─────────────────────────────────────────────────────────────┐
│              Node.js/Express Backend                        │
│          (Port 5000, CORS Enabled)                         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Routes Layer                                               │
│  ├─ /restaurants                                            │
│  ├─ /menu                                                   │
│  ├─ /cart                                                   │
│  └─ /orders                                                 │
│                                                              │
│  Controllers Layer                                          │
│  ├─ restaurantController                                    │
│  ├─ menuController                                          │
│  ├─ cartController                                          │
│  └─ orderController                                         │
│                                                              │
│  Models Layer (Mongoose)                                   │
│  ├─ Restaurant Schema                                       │
│  ├─ MenuItem Schema                                         │
│  ├─ Cart Schema (TTL Expiry)                               │
│  └─ Order Schema                                            │
│                                                              │
│  Middleware                                                 │
│  ├─ CORS                                                    │
│  ├─ Error Handler                                           │
│  └─ Body Parser                                             │
│                                                              │
└────────────────────┬────────────────────────────────────────┘
                     │ Mongoose ODM
                     │ (Query Builder)
                     ▼
┌─────────────────────────────────────────────────────────────┐
│            MongoDB Database                                 │
│   (Local or MongoDB Atlas)                                 │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Collections                                                │
│  ├─ restaurants (6 documents)                              │
│  ├─ menuitems (30+ documents)                              │
│  ├─ carts (session-based, TTL: 7 days)                    │
│  └─ orders                                                  │
│                                                              │
│  Indexes                                                    │
│  ├─ restaurantId (MenuItem)                                │
│  ├─ sessionId (Cart) - Unique                              │
│  ├─ rating (Restaurant)                                    │
│  └─ createdAt (All collections)                            │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## 📐 Data Flow

### 1. App Launch Flow
```
App Start
  ↓
SessionManager.initializeSession() [Generate unique session ID]
  ↓
SplashScreen (Show animation)
  ↓
CartProvider.initializeCart() [Load/create cart from backend]
  ↓
RestaurantProvider.fetchRestaurants() [Get all restaurants]
  ↓
HomeScreen (Display restaurants)
```

### 2. Add to Cart Flow
```
User taps "Add" on menu item
  ↓
App validates quantity
  ↓
ApiService.addToCart() [POST /cart]
  ↓
Backend:
  - Find/create cart by sessionId
  - Check restaurant consistency
  - Add item to cart
  - Save to MongoDB
  ↓
CartProvider updates state
  ↓
UI reflects changes (badge count, etc.)
```

### 3. Checkout Flow
```
User fills checkout form
  ↓
Form validation
  ↓
ApiService.createOrder() [POST /orders]
  ↓
Backend:
  - Validate order data
  - Create order document
  - Clear cart items
  - Return order details
  ↓
OrderProvider stores order
  ↓
Navigate to OrderSuccessScreen
```

### 4. Cart Persistence
```
App Session
  ↓
CartProvider stores session ID
  ↓
On app close → cart data remains in MongoDB
  ↓
Next app launch → CartProvider.initializeCart()
  ↓
Backend loads cart from sessionId
  ↓
Cart automatically restored!
  ↓
All items preserved (quantity, prices, etc.)
```

## 🏗️ Component Breakdown

### Frontend Components

#### Models (`lib/models/models.dart`)
- `Restaurant` - Restaurant details
- `MenuItem` - Menu item with pricing
- `CartItem` - Item + quantity in cart
- `Cart` - Session-based cart container
- `Order` - Order with full details

#### Providers (`lib/providers/`)

**RestaurantProvider**
- Manages restaurant list
- Handles search & filtering
- Fetches from `/restaurants` API
- Maintains loading/error states

**CartProvider**
- Session-based persistent cart
- Add/remove/update items
- Syncs with backend
- Auto-restores on app launch

**OrderProvider**
- Manages order creation
- Tracks order status
- Stores current order details
- Can fetch order history

#### Services (`lib/services/api_service.dart`)
- Centralized HTTP client
- All API endpoints in one place
- Error handling with try-catch
- JSON parsing with models
- Session ID management

#### Screens (`lib/screens/`)
- **SplashScreen** - Init app, load data
- **HomeScreen** - Browse restaurants, filter
- **RestaurantDetailsScreen** - View menu, add items
- **CartScreen** - Review items, edit quantities
- **CheckoutScreen** - Delivery form, payment method
- **OrderSuccessScreen** - Confirmation animation

#### Widgets (`lib/widgets/`)
- **RestaurantCard** - Responsive restaurant display
- **CategoryChip** - Filter selection

### Backend Components

#### Models (`backend/models/`)
- **Restaurant.js** - Schema with delivery fees
- **MenuItem.js** - Schema with restaurantId ref
- **Cart.js** - Session-based, TTL cleanup
- **Order.js** - Complete order snapshot

#### Controllers (`backend/controllers/`)
- **restaurantController** - GET all/one
- **menuController** - GET menu items
- **cartController** - CRUD operations
- **orderController** - Create/read orders

#### Routes (`backend/routes/`)
- **restaurants.js** - `/restaurants` endpoints
- **menu.js** - `/menu` endpoints
- **cart.js** - `/cart` endpoints
- **orders.js** - `/orders` endpoints

## 🔄 State Management

### Frontend State (Provider Pattern)

```
RestaurantProvider (ChangeNotifier)
├─ _restaurants: List<Restaurant>
├─ _filteredRestaurants: List<Restaurant>
├─ _searchQuery: String
├─ _selectedCuisine: String
├─ _isLoading: bool
└─ _error: String?

CartProvider (ChangeNotifier)
├─ _cart: Cart?
├─ _isLoading: bool
├─ _error: String?
└─ Methods: fetch, add, update, remove, clear

OrderProvider (ChangeNotifier)
├─ _currentOrder: Order?
├─ _orders: List<Order>
├─ _isLoading: bool
├─ _error: String?
└─ Methods: create, fetch, updateStatus
```

### Backend State (MongoDB)

All state persisted in database:
- Restaurants (static)
- Menu items (static)
- Carts (session-based, 7-day TTL)
- Orders (permanent)

## 🔐 Data Persistence

### Cart Persistence Strategy
1. **Session ID** - Generated per app installation (UUID)
2. **Backend Storage** - All cart data in MongoDB
3. **TTL Cleanup** - 7-day expiration after last update
4. **Auto-restore** - On app launch, cart fetched from sessionId

### Why Server-side Cart?
✅ Data persists across app restarts
✅ Works across all platforms (mobile, web, desktop)
✅ Can switch devices seamlessly
✅ Prevents data loss
✅ Supports multiple sessions per user

## 🎨 Responsive Design System

### Breakpoints
```
Mobile:  width < 600px   [Single column]
Tablet:  600 ≤ width < 1024  [2 columns]
Desktop: width ≥ 1024    [3 columns]
```

### Layout Adaptations

**Mobile (< 600px)**
- Single column restaurant list
- Full-width cards
- Bottom action buttons
- Simplified forms

**Tablet (600-1024px)**
- 2-column grid
- Larger card sizing
- Side-by-side content
- Optimized spacing

**Desktop (≥ 1024px)**
- 3-column grid
- Sidebar navigation
- Content max-width 1200px
- Hover interactions

## 📡 API Response Format

All endpoints follow consistent format:

```json
{
  "success": true,
  "data": { /* actual data */ }
}

// Error response
{
  "success": false,
  "message": "Error description"
}
```

## 🔌 API Endpoints Summary

| Method | Path | Purpose |
|--------|------|---------|
| GET | /restaurants | All restaurants |
| GET | /restaurants/:id | One restaurant |
| GET | /menu/:restaurantId | Restaurant menu |
| GET | /cart | Get cart by sessionId |
| POST | /cart | Add to cart |
| PUT | /cart | Update quantity |
| DELETE | /cart | Remove from cart |
| POST | /cart/clear | Clear entire cart |
| POST | /orders | Create order |
| GET | /orders/:id | Get order details |
| GET | /orders | All orders |
| PUT | /orders/:id/status | Update status |

## 🚀 Performance Optimizations

### Frontend
- Provider caching (notifications only when changed)
- Image lazy loading
- Pagination ready (future)
- Error retry logic

### Backend
- MongoDB indexes on frequently searched fields
- Mongoose connection pooling
- CORS pre-flight caching
- Gzip compression

### Database
- TTL indexes for cart cleanup
- Compound indexes for complex queries
- Connection string pooling

---

**This architecture ensures scalability, maintainability, and production-readiness.**
