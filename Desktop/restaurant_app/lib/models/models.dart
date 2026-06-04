class Restaurant {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final int deliveryTime;
  final double deliveryFee;
  final double minOrder;
  final String cuisine;
  final String category;
  final double averagePrice;
  final bool isOpen;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.minOrder,
    required this.cuisine,
    required this.category,
    required this.averagePrice,
    required this.isOpen,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    final categoryValue = json['category'] ?? json['cuisine'] ?? 'Mixed';
    final dynamic averagePriceValue = json['averagePrice'] ?? json['avgPrice'] ?? 0;
    final double averagePrice = averagePriceValue is num
        ? averagePriceValue.toDouble()
        : double.tryParse(averagePriceValue.toString()) ?? 0.0;

    return Restaurant(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      rating: (json['rating'] ?? 4.5).toDouble(),
      deliveryTime: json['deliveryTime'] ?? 30,
      deliveryFee: (json['deliveryFee'] ?? 15).toDouble(),
      minOrder: (json['minOrder'] ?? 50).toDouble(),
      cuisine: json['cuisine'] ?? 'Mixed',
      category: categoryValue as String,
      averagePrice: averagePrice,
      isOpen: json['isOpen'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'description': description,
    'imageUrl': imageUrl,
    'rating': rating,
    'deliveryTime': deliveryTime,
    'deliveryFee': deliveryFee,
    'minOrder': minOrder,
    'cuisine': cuisine,
    'category': category,
    'averagePrice': averagePrice,
    'isOpen': isOpen,
  };
}

class MenuItem {
  final String id;
  final String restaurantId;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final bool isAvailable;
  final double rating;

  MenuItem({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.isAvailable,
    required this.rating,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['_id'] ?? '',
      restaurantId: json['restaurantId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
      rating: (json['rating'] ?? 4.5).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'restaurantId': restaurantId,
    'name': name,
    'description': description,
    'price': price,
    'imageUrl': imageUrl,
    'category': category,
    'isAvailable': isAvailable,
    'rating': rating,
  };
}

class CartItem {
  final String menuItemId;
  final String restaurantId;
  final int quantity;
  final double price;
  final String name;

  CartItem({
    required this.menuItemId,
    required this.restaurantId,
    required this.quantity,
    required this.price,
    required this.name,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      menuItemId: json['menuItemId'] ?? '',
      restaurantId: json['restaurantId'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'menuItemId': menuItemId,
    'restaurantId': restaurantId,
    'quantity': quantity,
    'price': price,
    'name': name,
  };

  double get totalPrice => price * quantity;
}

class Cart {
  final String sessionId;
  final List<CartItem> items;
  final String? restaurantId;

  Cart({
    required this.sessionId,
    required this.items,
    this.restaurantId,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      sessionId: json['sessionId'] ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => CartItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      restaurantId: json['restaurantId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'sessionId': sessionId,
    'items': items.map((item) => item.toJson()).toList(),
    'restaurantId': restaurantId,
  };

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}

class Order {
  final String id;
  final String customerName;
  final String phone;
  final String address;
  final String email;
  final List<dynamic> items;
  final String restaurantId;
  final double subtotal;
  final double deliveryFee;
  final double totalAmount;
  final String status;
  final String paymentMethod;
  final String notes;
  final int estimatedDeliveryTime;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.email,
    required this.items,
    required this.restaurantId,
    required this.subtotal,
    required this.deliveryFee,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    required this.notes,
    required this.estimatedDeliveryTime,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'] ?? '',
      customerName: json['customerName'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      email: json['email'] ?? '',
      items: json['items'] ?? [],
      restaurantId: json['restaurantId'] ?? '',
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      deliveryFee: (json['deliveryFee'] ?? 0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      paymentMethod: json['paymentMethod'] ?? 'cash',
      notes: json['notes'] ?? '',
      estimatedDeliveryTime: json['estimatedDeliveryTime'] ?? 30,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'customerName': customerName,
    'phone': phone,
    'address': address,
    'email': email,
    'items': items,
    'restaurantId': restaurantId,
    'subtotal': subtotal,
    'deliveryFee': deliveryFee,
    'totalAmount': totalAmount,
    'status': status,
    'paymentMethod': paymentMethod,
    'notes': notes,
    'estimatedDeliveryTime': estimatedDeliveryTime,
    'createdAt': createdAt.toIso8601String(),
  };

  String get statusDisplay {
    switch (status) {
      case 'confirmed':
        return 'Order Confirmed';
      case 'preparing':
        return 'Preparing';
      case 'on-way':
        return 'On The Way';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Pending';
    }
  }
}
