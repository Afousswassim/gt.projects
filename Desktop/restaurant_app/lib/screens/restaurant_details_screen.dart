import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../data/dummy_menu_items.dart';
import '../providers/cart_provider.dart';
import '../services/api_service.dart';
import '../utils/helpers.dart';
import 'cart_screen.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  static const routeName = '/restaurant-details';
  final Restaurant restaurant;

  const RestaurantDetailsScreen({
    Key? key,
    required this.restaurant,
  }) : super(key: key);

  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  late Future<List<MenuItem>> _menuFuture;
  Map<String, int> _quantities = {};

  @override
  void initState() {
    super.initState();
    _menuFuture = ApiService.getMenuByRestaurant(widget.restaurant.id);
  }

  void _addToCart(MenuItem item) async {
    try {
      final cartProvider = context.read<CartProvider>();

      if (!cartProvider.hasRestaurantItems(widget.restaurant.id)) {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Clear Cart?'),
            content: const Text(
              'Your cart contains items from another restaurant. Replace them?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Replace'),
              ),
            ],
          ),
        );

        if (confirmed != true) return;
        await cartProvider.clearCart();
      }

      await cartProvider.addToCart(
        menuItem: item,
        restaurantId: widget.restaurant.id,
        quantity: _quantities[item.id] ?? 1,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.name} added to cart'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = ResponsiveUtil.isSmallScreen(size.width);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurant.name),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRestaurantHeader(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRestaurantInfo(),
                  const SizedBox(height: 24),
                  _buildMenuSection(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.items.isEmpty) return const SizedBox.shrink();

          return FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
            label: Text('View Cart (${cart.totalQuantity})'),
            icon: const Icon(Icons.shopping_cart),
            backgroundColor: Colors.deepOrange,
          );
        },
      ),
    );
  }

  Widget _buildRestaurantHeader() {
    return Stack(
      children: [
        Image.network(
          widget.restaurant.imageUrl,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: double.infinity,
            height: 200,
            color: Colors.grey.shade300,
            child: const Icon(Icons.restaurant, size: 80, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildRestaurantInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.restaurant.name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.restaurant.description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          children: [
            Chip(
              avatar: const Icon(Icons.star, size: 18),
              label: Text('${widget.restaurant.rating}'),
              backgroundColor: Colors.orange.shade100,
            ),
            Chip(
              avatar: const Icon(Icons.timer, size: 18),
              label: Text('${widget.restaurant.deliveryTime} min'),
              backgroundColor: Colors.blue.shade100,
            ),
            Chip(
              avatar: const Icon(Icons.local_shipping, size: 18),
              label: Text(CurrencyFormatter.formatDH(widget.restaurant.deliveryFee)),
              backgroundColor: Colors.green.shade100,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuSection() {
    return FutureBuilder<List<MenuItem>>(
      future: _menuFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Loading menu...',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }

        List<MenuItem> items = snapshot.data ?? [];

        if (snapshot.hasError || items.isEmpty) {
          items = dummyMenuItems
              .where((item) => item.restaurantId == widget.restaurant.id)
              .toList();

          if (items.isEmpty) {
            items = dummyMenuItems;
          }
        }

        if (items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Menu unavailable',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please try again later',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                ],
              ),
            ),
          );
        }

        final groupedByCategory = <String, List<MenuItem>>{};
        for (var item in items) {
          groupedByCategory.putIfAbsent(item.category, () => []).add(item);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: groupedByCategory.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...entry.value.map((item) => _buildMenuItemCard(item)),
                const SizedBox(height: 24),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildMenuItemCard(MenuItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.imageUrl.isNotEmpty
                    ? item.imageUrl
                    : 'https://images.unsplash.com/photo-1495195134139-0d4517b28b9f?w=400&h=300&fit=crop',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.fastfood, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        CurrencyFormatter.formatDH(item.price),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.deepOrange,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline,
                                size: 20),
                            onPressed: (_quantities[item.id] ?? 1) > 1
                                ? () => setState(() {
                                    _quantities[item.id] =
                                        (_quantities[item.id] ?? 1) - 1;
                                  })
                                : null,
                          ),
                          Text(
                            '${_quantities[item.id] ?? 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, size: 20),
                            onPressed: () => setState(() {
                              _quantities[item.id] =
                                  (_quantities[item.id] ?? 1) + 1;
                            }),
                          ),
                          ElevatedButton(
                            onPressed: () => _addToCart(item),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            child: const Text(
                              'Add',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
