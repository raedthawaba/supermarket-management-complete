import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _usersKey = 'users';
  static const String _productsKey = 'products';
  static const String _salesKey = 'sales';
  static const String _inventoryKey = 'inventory';
  static const String _expensesKey = 'expenses';
  static const String _currentUserKey = 'current_user';
  static const String _settingsKey = 'settings';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences? get prefs => _prefs;

  // Generic storage methods
  static Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  static Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  static Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  static bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  static int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  static bool containsKey(String key) {
    return _prefs?.containsKey(key) ?? false;
  }

  // User management
  static Future<void> saveUsers(List<Map<String, dynamic>> users) async {
    await setString(_usersKey, json.encode(users));
  }

  static List<Map<String, dynamic>> getUsers() {
    final usersString = getString(_usersKey);
    if (usersString != null) {
      final List<dynamic> usersList = json.decode(usersString);
      return usersList.cast<Map<String, dynamic>>();
    }
    return [];
  }

  // Products management
  static Future<void> saveProducts(List<Map<String, dynamic>> products) async {
    await setString(_productsKey, json.encode(products));
  }

  static List<Map<String, dynamic>> getProducts() {
    final productsString = getString(_productsKey);
    if (productsString != null) {
      final List<dynamic> productsList = json.decode(productsString);
      return productsList.cast<Map<String, dynamic>>();
    }
    return [];
  }

  // Sales management
  static Future<void> saveSales(List<Map<String, dynamic>> sales) async {
    await setString(_salesKey, json.encode(sales));
  }

  static List<Map<String, dynamic>> getSales() {
    final salesString = getString(_salesKey);
    if (salesString != null) {
      final List<dynamic> salesList = json.decode(salesString);
      return salesList.cast<Map<String, dynamic>>();
    }
    return [];
  }

  // Inventory management
  static Future<void> saveInventory(List<Map<String, dynamic>> inventory) async {
    await setString(_inventoryKey, json.encode(inventory));
  }

  static List<Map<String, dynamic>> getInventory() {
    final inventoryString = getString(_inventoryKey);
    if (inventoryString != null) {
      final List<dynamic> inventoryList = json.decode(inventoryString);
      return inventoryList.cast<Map<String, dynamic>>();
    }
    return [];
  }

  // Expenses management
  static Future<void> saveExpenses(List<Map<String, dynamic>> expenses) async {
    await setString(_expensesKey, json.encode(expenses));
  }

  static List<Map<String, dynamic>> getExpenses() {
    final expensesString = getString(_expensesKey);
    if (expensesString != null) {
      final List<dynamic> expensesList = json.decode(expensesString);
      return expensesList.cast<Map<String, dynamic>>();
    }
    return [];
  }

  // Current user management
  static Future<void> saveCurrentUser(Map<String, dynamic> user) async {
    await setString(_currentUserKey, json.encode(user));
  }

  static Map<String, dynamic>? getCurrentUser() {
    final userString = getString(_currentUserKey);
    if (userString != null) {
      return json.decode(userString) as Map<String, dynamic>;
    }
    return null;
  }

  static Future<void> clearCurrentUser() async {
    await _prefs?.remove(_currentUserKey);
  }

  // Settings management
  static Future<void> saveSettings(Map<String, dynamic> settings) async {
    await setString(_settingsKey, json.encode(settings));
  }

  static Map<String, dynamic> getSettings() {
    final settingsString = getString(_settingsKey);
    if (settingsString != null) {
      return json.decode(settingsString) as Map<String, dynamic>;
    }
    return {
      'theme': 'light',
      'currency': 'SAR',
      'language': 'ar',
      'notifications': true,
    };
  }

  // Clear all data
  static Future<void> clearAll() async {
    await _prefs?.clear();
  }
}