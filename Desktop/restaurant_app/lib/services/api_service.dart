import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/models.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000';
  static const Duration timeoutDuration = Duration(seconds: 30);

  static Future<dynamic> _makeRequest(
    String method,
    String endpoint, {
    dynamic body,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      late http.Response response;

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      switch (method.toUpperCase()) {
        case 'GET':
          response = await http
              .get(uri, headers: headers)
              .timeout(timeoutDuration, onTimeout: () {
            throw Exception('Request timeout after ${timeoutDuration.inSeconds}s');
          });
          break;
        case 'POST':
          response = await http
              .post(
                uri,
                headers: headers,
                body: jsonEncode(body),
              )
              .timeout(timeoutDuration, onTimeout: () {
            throw Exception('Request timeout after ${timeoutDuration.inSeconds}s');
          });
          break;
        case 'PUT':
          response = await http
              .put(
                uri,
                headers: headers,
                body: jsonEncode(body),
              )
              .timeout(timeoutDuration, onTimeout: () {
            throw Exception('Request timeout after ${timeoutDuration.inSeconds}s');
          });
          break;
        case 'DELETE':
          response = await http
              .delete(
                uri,
                headers: headers,
                body: jsonEncode(body),
              )
              .timeout(timeoutDuration, onTimeout: () {
            throw Exception('Request timeout after ${timeoutDuration.inSeconds}s');
          });
          break;
        default:
          throw Exception('Invalid HTTP method: $method');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          return jsonResponse['data'];
        } else {
          throw Exception(
            jsonResponse['message'] ?? 'Request failed',
          );
        }
      } else {
        final jsonResponse = jsonDecode(response.body);
        throw Exception(
          jsonResponse['message'] ?? 'Request failed with status ${response.statusCode}',
        );
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}. Please check your connection.');
    } on Exception catch (e) {
      if (e.toString().contains('Connection refused')) {
        throw Exception('Cannot connect to server. Ensure backend is running on $baseUrl');
      }
      rethrow;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Restaurant endpoints
  static Future<List<dynamic>> getRestaurants() async {
    final data = await _makeRequest('GET', '/restaurants');
    return List.from(data);
  }

  static Future<dynamic> getRestaurantById(String id) async {
    return await _makeRequest('GET', '/restaurants/$id');
  }

  // Menu endpoints
  static Future<List<MenuItem>> getMenuByRestaurant(String restaurantId) async {
    final data = await _makeRequest('GET', '/menu/$restaurantId');
    return List.from(data)
        .map((item) => MenuItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static Future<dynamic> getMenuItemById(String id) async {
    return await _makeRequest('GET', '/menu/item/$id');
  }

  // Cart endpoints
  static Future<dynamic> getCart(String sessionId) async {
    return await _makeRequest('GET', '/cart?sessionId=$sessionId');
  }

  static Future<dynamic> addToCart({
    required String sessionId,
    required String menuItemId,
    required int quantity,
    required String restaurantId,
  }) async {
    return await _makeRequest(
      'POST',
      '/cart',
      body: {
        'sessionId': sessionId,
        'menuItemId': menuItemId,
        'quantity': quantity,
        'restaurantId': restaurantId,
      },
    );
  }

  static Future<dynamic> updateCartItem({
    required String sessionId,
    required String menuItemId,
    required int quantity,
  }) async {
    return await _makeRequest(
      'PUT',
      '/cart',
      body: {
        'sessionId': sessionId,
        'menuItemId': menuItemId,
        'quantity': quantity,
      },
    );
  }

  static Future<dynamic> removeFromCart({
    required String sessionId,
    required String menuItemId,
  }) async {
    return await _makeRequest(
      'DELETE',
      '/cart',
      body: {
        'sessionId': sessionId,
        'menuItemId': menuItemId,
      },
    );
  }

  static Future<dynamic> clearCart(String sessionId) async {
    return await _makeRequest(
      'POST',
      '/cart/clear',
      body: {'sessionId': sessionId},
    );
  }

  // Order endpoints
  static Future<dynamic> createOrder({
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
    return await _makeRequest(
      'POST',
      '/orders',
      body: {
        'sessionId': sessionId,
        'customerName': customerName,
        'phone': phone,
        'address': address,
        'restaurantId': restaurantId,
        'email': email ?? '',
        'notes': notes ?? '',
        'deliveryFee': deliveryFee ?? 15,
        'paymentMethod': paymentMethod ?? 'cash',
      },
    );
  }

  static Future<dynamic> getOrder(String orderId) async {
    return await _makeRequest('GET', '/orders/$orderId');
  }

  static Future<List<dynamic>> getAllOrders() async {
    final data = await _makeRequest('GET', '/orders');
    return List.from(data);
  }

  static Future<dynamic> updateOrderStatus(
    String orderId,
    String status,
  ) async {
    return await _makeRequest(
      'PUT',
      '/orders/$orderId/status',
      body: {'status': status},
    );
  }
}
