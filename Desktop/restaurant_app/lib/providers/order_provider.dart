import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class OrderProvider with ChangeNotifier {
  Order? _currentOrder;
  List<Order> _orders = [];
  bool _isLoading = false;
  String? _error;

  Order? get currentOrder => _currentOrder;
  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> createOrder({
    required String sessionId,
    required String customerName,
    required String phone,
    required String address,
    required String restaurantId,
    String? email,
    String? notes,
    double? deliveryFee,
    String? paymentMethod,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await ApiService.createOrder(
        sessionId: sessionId,
        customerName: customerName,
        phone: phone,
        address: address,
        restaurantId: restaurantId,
        email: email,
        notes: notes,
        deliveryFee: deliveryFee,
        paymentMethod: paymentMethod,
      );
      _currentOrder = Order.fromJson(data as Map<String, dynamic>);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _currentOrder = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOrder(String orderId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await ApiService.getOrder(orderId);
      _currentOrder = Order.fromJson(data as Map<String, dynamic>);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await ApiService.getAllOrders();
      _orders = (data as List)
          .map((item) => Order.fromJson(item as Map<String, dynamic>))
          .toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _orders = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    _error = null;
    try {
      final data = await ApiService.updateOrderStatus(orderId, status);
      _currentOrder = Order.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }

  void clearCurrentOrder() {
    _currentOrder = null;
    notifyListeners();
  }
}
