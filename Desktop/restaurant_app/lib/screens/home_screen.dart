import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/restaurant_provider.dart';
import '../providers/cart_provider.dart';
import '../utils/helpers.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/category_chip.dart';
import 'restaurant_details_screen.dart';
import 'cart_screen.dart';

// Home Screen showing location picker, category filters, search and list of restaurants
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _categories = [
    {'name': 'All', 'icon': '🍽️'},
    {'name': 'Burgers', 'icon': '🍔'},
    {'name': 'Pizza', 'icon': '🍕'},
    {'name': 'Sushi', 'icon': '🍣'},
    {'name': 'Salads', 'icon': '🥗'},
    {'name': 'Desserts', 'icon': '🍰'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Custom App Bar (Location Selector & Cart Badge)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Location info
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: theme.colorScheme.primary,
                          size: 28,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Deliver to',
                              style: TextStyle(
                                fontSize: 11,
                                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '942 Maple Avenue, NY',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Shopping bag/cart badge
                    Consumer<CartProvider>(
                      builder: (context, cart, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.shopping_bag_outlined, size: 28),
                              onPressed: () {
                                Navigator.of(context).pushNamed(CartScreen.routeName);
                              },
                            ),
                            if (cart.totalQuantity > 0)
                              Positioned(
                                right: 6,
                                top: 6,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 1.5),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 18,
                                    minHeight: 18,
                                  ),
                                  child: Text(
                                    '${cart.totalQuantity}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Welcome/Greeting Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hey Foodie! 👋',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'What are you craving today?',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.6,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search and Filter Layout
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Consumer<RestaurantProvider>(
                  builder: (context, provider, child) {
                    return Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) {
                                provider.setSearchQuery(value);
                              },
                              decoration: InputDecoration(
                                hintText: 'Search restaurants, dishes...',
                                hintStyle: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                                ),
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
                                ),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear_rounded),
                                        onPressed: () {
                                          _searchController.clear();
                                          provider.setSearchQuery('');
                                        },
                                      )
                                    : null,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            Icons.tune_rounded,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // Horizontal Categories Scroll Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  height: 48,
                  child: Consumer<RestaurantProvider>(
                    builder: (context, provider, child) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 20, right: 8),
                        itemCount: _categories.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final categoryName = category['name'] as String;
                          final isSelected = provider.selectedCategory == categoryName;

                          return CategoryChip(
                            label: '${category['icon']}  $categoryName',
                            isSelected: isSelected,
                            onTap: () {
                              provider.selectCategory(categoryName);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),

            // Section Label
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Popular Restaurants',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.4,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'See All',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Restaurants list or Empty filter result screen
            Consumer<RestaurantProvider>(
              builder: (context, provider, child) {
                final restaurants = provider.restaurants;

                if (restaurants.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 80,
                            color: theme.colorScheme.outline.withOpacity(0.4),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No Restaurants Found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "We couldn't find any matching restaurants. Try search for other foods or reset the category.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 24),
                          FilledButton(
                            onPressed: () {
                              _searchController.clear();
                              provider.setSearchQuery('');
                              provider.selectCategory('All');
                            },
                            child: const Text('Reset Filters'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final restaurant = restaurants[index];
                        return RestaurantCard(
                          restaurant: restaurant,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => RestaurantDetailsScreen(
                                  restaurant: restaurant,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      childCount: restaurants.length,
                    ),
                  ),
                );
              },
            ),
            
            // Bottom spacer for scroll comfort
            const SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),
          ],
        ),
      ),
    );
  }
}
