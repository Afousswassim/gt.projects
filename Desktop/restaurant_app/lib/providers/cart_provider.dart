import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../utils/helpers.dart';

class CartProvider with ChangeNotifier {
  Cart? _cart;
  bool _isLoading = false;
  String? _error;

  Cart? get cart => _cart;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  List<CartItem> get items => _cart?.items ?? [];
  int get itemCount => items.length;
  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => _cart?.subtotal ?? 0;
  double get totalAmount => (_cart?.subtotal ?? 0) + 15;

  Future<void> initializeCart() async {
    SessionManager.initializeSession();
    await fetchCart();
  }

  Future<void> fetchCart() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await ApiService.getCart(SessionManager.sessionId);
      _cart = Cart.fromJson(data as Map<String, dynamic>);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _cart = Cart(sessionId: SessionManager.sessionId, items: []);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart({
    required MenuItem menuItem,
    required String restaurantId,
    int quantity = 1,
  }) async {
    _error = null;
    try {
      final data = await ApiService.addToCart(
        sessionId: SessionManager.sessionId,
        menuItemId: menuItem.id,
        quantity: quantity,
        restaurantId: restaurantId,
      );
      _cart = Cart.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }

  Future<void> updateQuantity(String menuItemId, int quantity) async {
    _error = null;
    try {
      final data = await ApiService.updateCartItem(
        sessionId: SessionManager.sessionId,
        menuItemId: menuItemId,
        quantity: quantity,
      );
      _cart = Cart.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }

  Future<void> removeItem(String menuItemId) async {
    _error = null;
    try {
      final data = await ApiService.removeFromCart(
        sessionId: SessionManager.sessionId,
        menuItemId: menuItemId,
      );
      _cart = Cart.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }

  Future<void> clearCart() async {
    _error = null;
    try {
      await ApiService.clearCart(SessionManager.sessionId);
      _cart = Cart(sessionId: SessionManager.sessionId, items: []);
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }

  bool hasRestaurantItems(String restaurantId) {
    return items.isEmpty || items.first.restaurantId == restaurantId;
  }
}
