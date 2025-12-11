import 'package:flutter/material.dart';
import '../models/models.dart';
import 'storage_service.dart';

class InventoryService extends ChangeNotifier {
  List<InventoryItem> _inventory = [];
  List<InventoryItem> get inventory => _inventory;

  Future<void> init() async {
    await StorageService.init();
    await loadInventory();
  }

  Future<void> loadInventory() async {
    final inventoryData = StorageService.getInventory();
    _inventory = inventoryData.map((itemData) => InventoryItem.fromJson(itemData)).toList();
    notifyListeners();
  }

  Future<void> addInventoryItem(InventoryItem item) async {
    _inventory.add(item);
    await _saveInventory();
    notifyListeners();
  }

  Future<void> updateInventoryItem(InventoryItem updatedItem) async {
    final index = _inventory.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _inventory[index] = updatedItem;
      await _saveInventory();
      notifyListeners();
    }
  }

  Future<void> deleteInventoryItem(String itemId) async {
    _inventory.removeWhere((item) => item.id == itemId);
    await _saveInventory();
    notifyListeners();
  }

  Future<void> _saveInventory() async {
    final inventoryJson = _inventory.map((item) => item.toJson()).toList();
    await StorageService.saveInventory(inventoryJson);
  }

  // Stock operations
  Future<void> adjustStock({
    required String productId,
    required String productName,
    required int quantityChange,
    required String reason,
    String? notes,
  }) async {
    final existingItemIndex = _inventory.indexWhere((item) => item.productId == productId);
    
    if (existingItemIndex != -1) {
      final existingItem = _inventory[existingItemIndex];
      final newQuantity = existingItem.quantity + quantityChange;
      
      if (newQuantity >= 0) {
        // Update existing item
        existingItem.quantity = newQuantity;
        existingItem.lastUpdated = DateTime.now();
        
        // Add stock movement record
        existingItem.movements.add(StockMovement(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          productId: productId,
          productName: productName,
          type: quantityChange > 0 ? MovementType.in : MovementType.out,
          quantity: quantityChange.abs(),
          reason: reason,
          notes: notes,
          timestamp: DateTime.now(),
          userId: '',
        ));
        
        await _saveInventory();
        notifyListeners();
      }
    } else {
      // Create new inventory item
      if (quantityChange > 0) {
        final newItem = InventoryItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          productId: productId,
          productName: productName,
          quantity: quantityChange,
          minStock: 10,
          maxStock: 1000,
          location: 'المستودع الرئيسي',
          lastUpdated: DateTime.now(),
          movements: [
            StockMovement(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              productId: productId,
              productName: productName,
              type: MovementType.in,
              quantity: quantityChange,
              reason: reason,
              notes: notes,
              timestamp: DateTime.now(),
              userId: '',
            ),
          ],
        );
        
        await addInventoryItem(newItem);
      }
    }
  }

  List<InventoryItem> getLowStockItems() {
    return _inventory.where((item) => item.quantity <= item.minStock).toList();
  }

  List<InventoryItem> getOutOfStockItems() {
    return _inventory.where((item) => item.quantity == 0).toList();
  }

  List<InventoryItem> searchInventory(String query) {
    if (query.isEmpty) return _inventory;
    
    return _inventory.where((item) {
      return item.productName.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Stock movement reports
  List<StockMovement> getStockMovementsByDateRange(DateTime start, DateTime end) {
    final List<StockMovement> movements = [];
    
    for (final item in _inventory) {
      movements.addAll(
        item.movements.where((movement) {
          return movement.timestamp.isAfter(start) && movement.timestamp.isBefore(end);
        }).toList(),
      );
    }
    
    // Sort by timestamp (newest first)
    movements.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    return movements;
  }

  Map<String, int> getStockInSummary(int days) {
    final Map<String, int> summary = {};
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days));
    
    for (final item in _inventory) {
      for (final movement in item.movements) {
        if (movement.type == MovementType.in && 
            movement.timestamp.isAfter(startDate)) {
          final dateKey = movement.timestamp.toIso8601String().split('T')[0];
          summary[dateKey] = (summary[dateKey] ?? 0) + movement.quantity;
        }
      }
    }
    
    return summary;
  }

  Map<String, int> getStockOutSummary(int days) {
    final Map<String, int> summary = {};
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days));
    
    for (final item in _inventory) {
      for (final movement in item.movements) {
        if (movement.type == MovementType.out && 
            movement.timestamp.isAfter(startDate)) {
          final dateKey = movement.timestamp.toIso8601String().split('T')[0];
          summary[dateKey] = (summary[dateKey] ?? 0) + movement.quantity;
        }
      }
    }
    
    return summary;
  }

  Future<void> createSampleInventory() async {
    if (_inventory.isNotEmpty) return;

    final sampleInventory = [
      InventoryItem(
        id: '1',
        productId: '1',
        productName: 'حليب كامل الدسم',
        quantity: 100,
        minStock: 20,
        maxStock: 500,
        location: 'المبرد الرئيسي',
        lastUpdated: DateTime.now(),
        movements: [],
      ),
      InventoryItem(
        id: '2',
        productId: '2',
        productName: 'خبز أبيض',
        quantity: 50,
        minStock: 10,
        maxStock: 200,
        location: 'المخبوزات',
        lastUpdated: DateTime.now(),
        movements: [],
      ),
    ];

    for (final item in sampleInventory) {
      await addInventoryItem(item);
    }
  }
}