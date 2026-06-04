import 'package:flutter/material.dart';
import '../data/dummy_restaurants.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class RestaurantProvider with ChangeNotifier {
  List<Restaurant> _restaurants = [];
  List<Restaurant> _filteredRestaurants = [];
  String _searchQuery = '';
  String _selectedCuisine = 'All';
  String selectedCategory = 'All';
  bool _isLoading = false;
  String? _error;

  List<Restaurant> get restaurants => _filteredRestaurants;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String get selectedCuisine => _selectedCuisine;

  Future<void> fetchRestaurants() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await ApiService.getRestaurants();
      _restaurants = (data as List)
          .map((item) => Restaurant.fromJson(item as Map<String, dynamic>))
          .toList();
      if (_restaurants.isEmpty) {
        _restaurants = dummyRestaurants;
      }
      _applyFilters();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _restaurants = dummyRestaurants;
      _filteredRestaurants = [];
      _applyFilters();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void selectCategory(String category) {
    selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void selectCuisine(String cuisine) {
    _selectedCuisine = cuisine;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredRestaurants = _restaurants.where((restaurant) {
      final matchesSearch = restaurant.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          restaurant.description.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory = selectedCategory == 'All' ||
          restaurant.name.toLowerCase().contains(selectedCategory.toLowerCase()) ||
          restaurant.description.toLowerCase().contains(selectedCategory.toLowerCase()) ||
          restaurant.cuisine.toLowerCase().contains(selectedCategory.toLowerCase());

      final matchesCuisine = _selectedCuisine == 'All' ||
          restaurant.cuisine.toLowerCase() == _selectedCuisine.toLowerCase();

      return matchesSearch && matchesCategory && matchesCuisine;
    }).toList();

    _filteredRestaurants.sort((a, b) => b.rating.compareTo(a.rating));
  }

  List<String> get cuisines {
    final Set<String> uniqueCuisines = {'All'};
    for (var restaurant in _restaurants) {
      uniqueCuisines.add(restaurant.cuisine);
    }
    return uniqueCuisines.toList();
  }
}
