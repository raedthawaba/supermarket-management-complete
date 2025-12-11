import 'package:flutter/material.dart';
import '../models/models.dart';
import 'storage_service.dart';

class SaleService extends ChangeNotifier {
  List<Sale> _sales = [];
  List<Sale> get sales => _sales;

  // Cart management
  Map<String, SaleItem> _cart = {};
  Map<String, SaleItem> get cart => _cart;
  
  double get cartTotal => _cart.values.fold(0.0, (sum, item) => sum + item.total);
  int get cartItemsCount => _cart.values.fold(0, (sum, item) => sum + item.quantity);

  Future<void> init() async {
    await StorageService.init();
    await loadSales();
  }

  Future<void> loadSales() async {
    final salesData = StorageService.getSales();
    _sales = salesData.map((saleData) => Sale.fromJson(saleData)).toList();
    notifyListeners();
  }

  Future<void> addSale(Sale sale) async {
    _sales.add(sale);
    await _saveSales();
    notifyListeners();
  }

  Future<void> _saveSales() async {
    final salesJson = _sales.map((sale) => sale.toJson()).toList();
    await StorageService.saveSales(salesJson);
  }

  // Cart operations
  void addToCart(Product product, {int quantity = 1}) {
    final existingItem = _cart[product.id];
    
    if (existingItem != null) {
      existingItem.quantity += quantity;
    } else {
      _cart[product.id] = SaleItem(
        productId: product.id,
        productName: product.name,
        price: product.price,
        quantity: quantity,
        total: product.price * quantity,
      );
    }
    
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cart.remove(productId);
    notifyListeners();
  }

  void updateCartItemQuantity(String productId, int quantity) {
    final item = _cart[productId];
    if (item != null) {
      if (quantity <= 0) {
        removeFromCart(productId);
      } else {
        item.quantity = quantity;
        item.total = item.price * quantity;
        notifyListeners();
      }
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  Future<Sale> completeSale({
    required String customerName,
    String paymentMethod = 'cash',
    double discount = 0.0,
  }) async {
    if (_cart.isEmpty) {
      throw Exception('Cart is empty');
    }

    final sale = Sale(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      customerName: customerName.isEmpty ? 'عميل نقدي' : customerName,
      items: _cart.values.toList(),
      total: cartTotal,
      discount: discount,
      finalTotal: cartTotal - discount,
      paymentMethod: paymentMethod,
      timestamp: DateTime.now(),
      userId: '',
    );

    await addSale(sale);
    clearCart();
    
    return sale;
  }

  // Reports and analytics
  List<Sale> getSalesByDateRange(DateTime start, DateTime end) {
    return _sales.where((sale) {
      return sale.timestamp.isAfter(start) && sale.timestamp.isBefore(end);
    }).toList();
  }

  double getTotalSalesByDateRange(DateTime start, DateTime end) {
    return getSalesByDateRange(start, end).fold(0.0, (sum, sale) => sum + sale.finalTotal);
  }

  List<Sale> getTodaysSales() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return getSalesByDateRange(startOfDay, endOfDay);
  }

  double getTodaysTotal() {
    return getTodaysSales().fold(0.0, (sum, sale) => sum + sale.finalTotal);
  }

  Map<String, int> getSalesByPaymentMethod() {
    final Map<String, int> paymentMethodCount = {};
    
    for (final sale in _sales) {
      paymentMethodCount[sale.paymentMethod] = 
          (paymentMethodCount[sale.paymentMethod] ?? 0) + 1;
    }
    
    return paymentMethodCount;
  }

  Map<String, double> getRevenueByDay(int days) {
    final Map<String, double> revenueByDay = {};
    final now = DateTime.now();
    
    for (int i = days - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayStart = DateTime(date.year, date.month, date.day);
      final dayEnd = dayStart.add(const Duration(days: 1));
      
      final daySales = getSalesByDateRange(dayStart, dayEnd);
      final dayRevenue = daySales.fold(0.0, (sum, sale) => sum + sale.finalTotal);
      
      revenueByDay[dayStart.toIso8601String().split('T')[0]] = dayRevenue;
    }
    
    return revenueByDay;
  }

  List<Map<String, dynamic>> getTopSellingProducts(int limit) {
    final Map<String, Map<String, dynamic>> productStats = {};
    
    for (final sale in _sales) {
      for (final item in sale.items) {
        if (!productStats.containsKey(item.productId)) {
          productStats[item.productId] = {
            'name': item.productName,
            'totalQuantity': 0,
            'totalRevenue': 0.0,
          };
        }
        
        productStats[item.productId]!['totalQuantity'] += item.quantity;
        productStats[item.productId]!['totalRevenue'] += item.total;
      }
    }
    
    return productStats.values.toList()
      ..sort((a, b) => b['totalQuantity'].compareTo(a['totalQuantity']))
      ..take(limit).toList();
  }
}