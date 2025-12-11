import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/inventory_service.dart';
import '../services/product_service.dart';
import '../widgets/custom_widgets.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filterType = 'الكل'; // All, Low Stock, Out of Stock
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    final inventoryService = ref.read(inventoryServiceProvider);
    final productService = ref.read(productServiceProvider);
    
    await inventoryService.init();
    await productService.init();
    await productService.createSampleProducts();
    await inventoryService.createSampleInventory();
    
    setState(() {
      _isInitialized = true;
    });
  }

  void _showAdjustStockDialog(InventoryItem item) {
    final quantityController = TextEditingController();
    final reasonController = TextEditingController();
    final notesController = TextEditingController();
    String movementType = 'in'; // in or out

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تعديل المخزون - ${item.productName}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'الكمية الحالية: ${item.quantity}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('نوع الحركة:'),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButton<String>(
                      value: movementType,
                      items: const [
                        DropdownMenuItem(value: 'in', child: Text('إضافة')),
                        DropdownMenuItem(value: 'out', child: Text('استخراج')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          movementType = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'الكمية *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  labelText: 'السبب *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'ملاحظات',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (quantityController.text.isEmpty || reasonController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('يرجى ملء جميع الحقول المطلوبة')),
                );
                return;
              }

              try {
                final quantity = int.parse(quantityController.text);
                final quantityChange = movementType == 'in' ? quantity : -quantity;
                final newQuantity = item.quantity + quantityChange;

                if (newQuantity < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('الكمية الجديدة لا يمكن أن تكون سالبة')),
                  );
                  return;
                }

                final inventoryService = ref.read(inventoryServiceProvider);
                await inventoryService.adjustStock(
                  productId: item.productId,
                  productName: item.productName,
                  quantityChange: quantityChange,
                  reason: reasonController.text,
                  notes: notesController.text.isEmpty ? null : notesController.text,
                );

                Navigator.pop(context);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم تعديل المخزون بنجاح')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('خطأ: ${e.toString()}')),
                );
              }
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  void _showStockMovementsDialog(InventoryItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('حركات المخزون - ${item.productName}'),
        content: SizedBox(
          width: double.maxFinite,
          child: item.movements.isEmpty
              ? const Center(child: Text('لا توجد حركات مخزون'))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: item.movements.length,
                  itemBuilder: (context, index) {
                    final movement = item.movements[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: Icon(
                          movement.type == MovementType.in ? Icons.arrow_downward : Icons.arrow_upward,
                          color: movement.type == MovementType.in ? Colors.green : Colors.red,
                        ),
                        title: Text('${movement.quantity} ${movement.type == MovementType.in ? '+' : '-'}${movement.quantity}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('السبب: ${movement.reason}'),
                            Text(
                              movement.timestamp.toLocal().toString().split(' ')[0],
                            ),
                            if (movement.notes != null && movement.notes!.isNotEmpty)
                              Text('ملاحظات: ${movement.notes}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المخزون'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard),
            onPressed: () => context.go('/dashboard'),
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final inventoryService = ref.watch(inventoryServiceProvider);
          
          List<InventoryItem> filteredItems = inventoryService.inventory;

          // Apply search filter
          if (_searchController.text.isNotEmpty) {
            filteredItems = inventoryService.searchInventory(_searchController.text);
          }

          // Apply type filter
          switch (_filterType) {
            case 'مخزون منخفض':
              filteredItems = inventoryService.getLowStockItems();
              break;
            case 'نفد المخزون':
              filteredItems = inventoryService.getOutOfStockItems();
              break;
            default:
              break;
          }

          return Column(
            children: [
              // Search and filter bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: 'البحث في المخزون...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    DropdownButton<String>(
                      value: _filterType,
                      items: const [
                        DropdownMenuItem(value: 'الكل', child: Text('الكل')),
                        DropdownMenuItem(value: 'مخزون منخفض', child: Text('مخزون منخفض')),
                        DropdownMenuItem(value: 'نفد المخزون', child: Text('نفد المخزون')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _filterType = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              // Inventory summary
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text('إجمالي المنتجات'),
                            Text(
                              '${inventoryService.inventory.length}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('مخزون منخفض'),
                            Text(
                              '${inventoryService.getLowStockItems().length}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('نفد المخزون'),
                            Text(
                              '${inventoryService.getOutOfStockItems().length}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Inventory list
              Expanded(
                child: filteredItems.isEmpty
                    ? const Center(
                        child: Text(
                          'لا توجد عناصر في المخزون',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          final isLowStock = item.quantity <= item.minStock;
                          final isOutOfStock = item.quantity == 0;

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            color: isOutOfStock
                                ? Colors.red.shade50
                                : isLowStock
                                    ? Colors.orange.shade50
                                    : null,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: isOutOfStock
                                    ? Colors.red
                                    : isLowStock
                                        ? Colors.orange
                                        : Colors.green,
                                child: Icon(
                                  isOutOfStock
                                      ? Icons.warning
                                      : isLowStock
                                          ? Icons.trending_down
                                          : Icons.check_circle,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                item.productName,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('الكمية: ${item.quantity}'),
                                  Text('الموقع: ${item.location}'),
                                  Text(
                                    'الحد الأدنى: ${item.minStock}',
                                    style: TextStyle(
                                      color: isLowStock ? Colors.red : null,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.timeline),
                                    onPressed: () => _showStockMovementsDialog(item),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _showAdjustStockDialog(item),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}