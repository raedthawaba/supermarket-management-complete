import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/product_service.dart';
import '../services/sale_service.dart';
import '../widgets/custom_widgets.dart';

class POSScreen extends ConsumerStatefulWidget {
  const POSScreen({super.key});

  @override
  ConsumerState<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends ConsumerState<POSScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  
  String _paymentMethod = 'cash';
  String _selectedCategory = 'الكل';
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    final productService = ref.read(productServiceProvider);
    final saleService = ref.read(saleServiceProvider);
    
    await productService.init();
    await saleService.init();
    
    // Create sample products if none exist
    await productService.createSampleProducts();
    
    setState(() {
      _isInitialized = true;
    });
  }

  List<Product> _filterProducts(List<Product> products, String query) {
    if (_selectedCategory != 'الكل') {
      products = products.where((p) => p.category == _selectedCategory).toList();
    }
    
    if (query.isNotEmpty) {
      products = products.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase()) ||
               product.barcode.contains(query);
      }).toList();
    }
    
    return products;
  }

  void _addToCart(Product product) {
    final saleService = ref.read(saleServiceProvider);
    saleService.addToCart(product);
    _showSnackBar('تم إضافة ${product.name} إلى السلة');
  }

  void _completeSale() {
    final saleService = ref.read(saleServiceProvider);
    if (saleService.cart.isEmpty) {
      _showSnackBar('السلة فارغة');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إتمام البيع'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _customerController,
              decoration: const InputDecoration(
                labelText: 'اسم العميل (اختياري)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _paymentMethod,
              decoration: const InputDecoration(
                labelText: 'طريقة الدفع',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'cash', child: Text('نقدي')),
                DropdownMenuItem(value: 'card', child: Text('بطاقة ائتمان')),
                DropdownMenuItem(value: 'bank_transfer', child: Text('حوالة بنكية')),
              ],
              onChanged: (value) {
                setState(() {
                  _paymentMethod = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _discountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'الخصم',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'الإجمالي: ${saleService.cartTotal.toStringAsFixed(2)} ريال',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final discount = double.tryParse(_discountController.text) ?? 0.0;
                
                final sale = await saleService.completeSale(
                  customerName: _customerController.text,
                  paymentMethod: _paymentMethod,
                  discount: discount,
                );

                Navigator.pop(context);
                _showSnackBar('تم إتمام البيع بنجاح');
                
                // Clear input fields
                _customerController.clear();
                _discountController.clear();
                _paymentMethod = 'cash';
                
              } catch (e) {
                _showSnackBar('خطأ في إتمام البيع: ${e.toString()}');
              }
            },
            child: const Text('إتمام البيع'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
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
        title: const Text('نقطة البيع'),
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
          final saleService = ref.watch(saleServiceProvider);
          
          final filteredProducts = _filterProducts(productService.products, _searchController.text);
          
          return Row(
            children: [
              // Products section (2/3 of screen)
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    // Search and filter bar
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) => setState(() {}),
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
                              ...productService.getCategories().map((category) {
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
                        ],
                      ),
                    ),
                    // Products grid
                    Expanded(
                      child: filteredProducts.isEmpty
                          ? const Center(
                              child: Text(
                                'لا توجد منتجات',
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.all(16),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 0.8,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                              itemCount: filteredProducts.length,
                              itemBuilder: (context, index) {
                                final product = filteredProducts[index];
                                return Card(
                                  elevation: 2,
                                  child: InkWell(
                                    onTap: () => _addToCart(product),
                                    borderRadius: BorderRadius.circular(8),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Center(
                                              child: Icon(
                                                Icons.inventory_2,
                                                size: 48,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            product.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${product.price.toStringAsFixed(2)} ريال',
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'المخزون: ${product.stock}',
                                            style: TextStyle(
                                              color: product.stock <= product.minStock
                                                  ? Colors.red
                                                  : Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              // Cart section (1/3 of screen)
              Container(
                width: 400,
                color: Colors.grey[100],
                child: Column(
                  children: [
                    // Cart header
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.blue,
                      child: Row(
                        children: [
                          const Icon(Icons.shopping_cart, color: Colors.white),
                          const SizedBox(width: 8),
                          const Text(
                            'السلة',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${saleService.cartItemsCount} عناصر',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    // Cart items
                    Expanded(
                      child: ListView.builder(
                        itemCount: saleService.cart.length,
                        itemBuilder: (context, index) {
                          final item = saleService.cart.values.elementAt(index);
                          final productId = saleService.cart.keys.elementAt(index);
                          
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: ListTile(
                              title: Text(
                                item.productName,
                                style: const TextStyle(fontSize: 14),
                              ),
                              subtitle: Text(
                                '${item.price.toStringAsFixed(2)} ريال',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      saleService.updateCartItemQuantity(
                                        productId,
                                        item.quantity - 1,
                                      );
                                    },
                                  ),
                                  Text(
                                    '${item.quantity}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      saleService.updateCartItemQuantity(
                                        productId,
                                        item.quantity + 1,
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () {
                                      saleService.removeFromCart(productId);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Cart summary and checkout
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, -1),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'الإجمالي:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${saleService.cartTotal.toStringAsFixed(2)} ريال',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: saleService.cart.isEmpty ? null : _completeSale,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text(
                                'إتمام البيع',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}