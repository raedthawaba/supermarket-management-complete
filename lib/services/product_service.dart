import 'package:flutter/material.dart';
import '../models/models.dart';
import 'storage_service.dart';

class ProductService extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products => _products;

  Future<void> init() async {
    await StorageService.init();
    await loadProducts();
  }

  Future<void> loadProducts() async {
    final productsData = StorageService.getProducts();
    _products = productsData.map((productData) => Product.fromJson(productData)).toList();
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    _products.add(product);
    await _saveProducts();
    notifyListeners();
  }

  Future<void> updateProduct(Product updatedProduct) async {
    final index = _products.indexWhere((product) => product.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
      await _saveProducts();
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String productId) async {
    _products.removeWhere((product) => product.id == productId);
    await _saveProducts();
    notifyListeners();
  }

  Future<void> _saveProducts() async {
    final productsJson = _products.map((product) => product.toJson()).toList();
    await StorageService.saveProducts(productsJson);
  }

  List<Product> searchProducts(String query) {
    if (query.isEmpty) return _products;
    
    return _products.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase()) ||
             product.barcode.contains(query) ||
             product.category.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  List<Product> getProductsByCategory(String category) {
    return _products.where((product) => product.category == category).toList();
  }

  List<String> getCategories() {
    return _products.map((product) => product.category).toSet().toList();
  }

  Future<void> updateStock(String productId, int newStock) async {
    final index = _products.indexWhere((product) => product.id == productId);
    if (index != -1) {
      _products[index].stock = newStock;
      await _saveProducts();
      notifyListeners();
    }
  }

  Future<void> createSampleProducts() async {
    if (_products.isNotEmpty) return;

    final sampleProducts = [
      Product(
        id: '1',
        name: 'حليب كامل الدسم',
        barcode: '1234567890123',
        category: 'منتجات الألبان',
        price: 15.50,
        cost: 10.00,
        stock: 100,
        minStock: 20,
        unit: 'عبوة',
        description: 'حليب كامل الدسم طازج',
        createdAt: DateTime.now(),
      ),
      Product(
        id: '2',
        name: 'خبز أبيض',
        barcode: '1234567890124',
        category: 'المخبوزات',
        price: 3.00,
        cost: 2.00,
        stock: 50,
        minStock: 10,
        unit: 'رغيف',
        description: 'خبز أبيض طازج',
        createdAt: DateTime.now(),
      ),
      Product(
        id: '3',
        name: 'دجاج مجمد',
        barcode: '1234567890125',
        category: 'اللحوم والدواجن',
        price: 25.00,
        cost: 18.00,
        stock: 30,
        minStock: 5,
        unit: 'كيلو',
        description: 'دجاج مجمد طازج',
        createdAt: DateTime.now(),
      ),
      Product(
        id: '4',
        name: 'أرز بسمتي',
        barcode: '1234567890126',
        category: 'الحبوب والبقوليات',
        price: 18.00,
        cost: 12.00,
        stock: 80,
        minStock: 15,
        unit: 'كيلو',
        description: 'أرز بسمتي فاخر',
        createdAt: DateTime.now(),
      ),
      Product(
        id: '5',
        name: 'زيت زيتون',
        barcode: '1234567890127',
        category: 'الزيوت والدهون',
        price: 35.00,
        cost: 25.00,
        stock: 40,
        minStock: 8,
        unit: 'لتر',
        description: 'زيت زيتون بكر ممتاز',
        createdAt: DateTime.now(),
      ),
    ];

    for (final product in sampleProducts) {
      await addProduct(product);
    }
  }
}