import '../data/dummy_restaurants.dart';
import '../data/dummy_menu_items.dart';
import '../models/models.dart';

class LocalDataHelper {
  static List<Restaurant> getFallbackRestaurants() {
    return dummyRestaurants;
  }

  static List<MenuItem> getFallbackMenuItems(String restaurantId) {
    return dummyMenuItems
        .where((item) => item.restaurantId == restaurantId)
        .toList();
  }

  static List<MenuItem> getAllFallbackMenuItems() {
    return dummyMenuItems;
  }

  static bool hasValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    return url.startsWith('http://') || url.startsWith('https://');
  }

  static String getPlaceholderImageUrl() {
    return 'https://images.unsplash.com/photo-1495195134139-0d4517b28b9f?w=400&h=300&fit=crop';
  }
}
