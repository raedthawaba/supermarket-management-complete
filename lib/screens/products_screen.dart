import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/product_service.dart';
import '../widgets/custom_widgets.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'الكل';
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    final productService = ref.read(productServiceProvider);
    await productService.init();
    await productService.createSampleProducts();
    setState(() {
      _isInitialized = true;
    });
  }

  void _showAddEditProductDialog({Product? product}) {
    final nameController = TextEditingController(text: product?.name ?? '');
    final barcodeController = TextEditingController(text: product?.barcode ?? '');
    final categoryController = TextEditingController(text: product?.category ?? '');
    final priceController = TextEditingController(text: product?.price.toString() ?? '');
    final costController = TextEditingController(text: product?.cost.toString() ?? '');
    final stockController = TextEditingController(text: product?.stock.toString() ?? '');
    final minStockController = TextEditingController(text: product?.minStock.toString() ?? '');
    final unitController = TextEditingController(text: product?.unit ?? '');
    final descriptionController = TextEditingController(text: product?.description ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product == null ? 'إضافة منتج' : 'تعديل منتج'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم المنتج *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: barcodeController,
                decoration: const InputDecoration(
                  labelText: 'الباركود *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'الفئة *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'سعر البيع *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: costController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'سعر التكلفة *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: stockController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'الكمية *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: minStockController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'الحد الأدنى *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: unitController,
                decoration: const InputDecoration(
                  labelText: 'الوحدة *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'الوصف',
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
              if (nameController.text.isEmpty ||
                  barcodeController.text.isEmpty ||
                  categoryController.text.isEmpty ||
                  priceController.text.isEmpty ||
                  costController.text.isEmpty ||
                  stockController.text.isEmpty ||
                  minStockController.text.isEmpty ||
                  unitController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('يرجى ملء جميع الحقول المطلوبة')),
                );
                return;
              }

              try {
                final newProduct = Product(
                  id: product?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  barcode: barcodeController.text,
                  category: categoryController.text,
                  price: double.parse(priceController.text),
                  cost: double.parse(costController.text),
                  stock: int.parse(stockController.text),
                  minStock: int.parse(minStockController.text),
                  unit: unitController.text,
                  description: descriptionController.text,
                  createdAt: product?.createdAt ?? DateTime.now(),
                );

                final productService = ref.read(productServiceProvider);
                if (product == null) {
                  await productService.addProduct(newProduct);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم إضافة المنتج بنجاح')),
                  );
                } else {
                  await productService.updateProduct(newProduct);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم تعديل المنتج بنجاح')),
                  );
                }

                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('خطأ: ${e.toString()}')),
                );
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _deleteProduct(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المنتج'),
        content: Text('هل أنت متأكد من حذف "${product.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final productService = ref.read(productServiceProvider);
              await productService.deleteProduct(product.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حذف المنتج بنجاح')),
              );
            },
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  List<String> getCategories(List<Product> products) {
    return products.map((product) => product.category).toSet().toList();
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
        title: const Text('إدارة المنتجات'),
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
          final productService = ref.watch(productServiceProvider);
          
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
                          hintText: 'البحث عن المنتجات...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    DropdownButton<String>(
                      value: _selectedCategory,
                      items: [
                        const DropdownMenuItem(
                          value: 'الكل',
                          child: Text('الكل'),
                        ),
                        ...getCategories(productService.products).map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () => _showAddEditProductDialog(),
                      icon: const Icon(Icons.add),
                      label: const Text('إضافة منتج'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    ),
                  ],
                ),
              ),
              // Products list
              Expanded(
                child: ListView.builder(
                  itemCount: productService.products.length,
                  itemBuilder: (context, index) {
                    final product = productService.products[index];
                    
                    // Apply filters
                    if (_searchController.text.isNotEmpty &&
                        !productService.searchProducts(_searchController.text).contains(product)) {
                      return const SizedBox.shrink();
                    }
                    
                    if (_selectedCategory != 'الكل' && product.category != _selectedCategory) {
                      return const SizedBox.shrink();
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: product.stock <= product.minStock
                              ? Colors.red
                              : Colors.blue,
                          child: const Icon(
                            Icons.inventory_2,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          product.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('الفئة: ${product.category}'),
                            Text('السعر: ${product.price.toStringAsFixed(2)} ريال'),
                            Text(
                              'المخزون: ${product.stock} ${product.unit}',
                              style: TextStyle(
                                color: product.stock <= product.minStock
                                    ? Colors.red
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _showAddEditProductDialog(product: product),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteProduct(product),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditProductDialog(),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}