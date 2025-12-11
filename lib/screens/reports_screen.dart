import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/models.dart';
import '../services/sale_service.dart';
import '../services/expense_service.dart';
import '../services/inventory_service.dart';
import '../widgets/custom_widgets.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  String _selectedReport = 'المبيعات';
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    final saleService = ref.read(saleServiceProvider);
    final expenseService = ref.read(expenseServiceProvider);
    final inventoryService = ref.read(inventoryServiceProvider);
    
    await saleService.init();
    await expenseService.init();
    await inventoryService.init();
    
    setState(() {
      _isInitialized = true;
    });
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  List<Widget> _buildSalesReport(SaleService saleService) {
    final sales = saleService.getSalesByDateRange(_startDate, _endDate);
    final totalSales = saleService.getTotalSalesByDateRange(_startDate, _endDate);
    final revenueByDay = saleService.getRevenueByDay(30);
    final topProducts = saleService.getTopSellingProducts(5);
    final paymentMethods = saleService.getSalesByPaymentMethod();

    return [
      // Summary cards
      Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'إجمالي المبيعات',
              '${totalSales.toStringAsFixed(2)} ريال',
              Icons.sell,
              Colors.green,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildSummaryCard(
              'عدد المعاملات',
              '${sales.length}',
              Icons.receipt,
              Colors.blue,
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      
      // Revenue chart
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'الإيرادات اليومية',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: revenueByDay.entries
                            .take(30)
                            .map((entry) => FlSpot(
                                  DateTime.parse(entry.key).day.toDouble(),
                                  entry.value,
                                ))
                            .toList(),
                        isCurved: true,
                        color: Colors.green,
                        barWidth: 3,
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.green.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),
      
      // Top selling products
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'أفضل المنتجات مبيعاً',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...topProducts.map((product) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    '${product['totalQuantity']}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(product['name']),
                subtitle: Text(
                  'الكمية المباعة: ${product['totalQuantity']} | الإيرادات: ${product['totalRevenue'].toStringAsFixed(2)} ريال',
                ),
              )),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),
      
      // Payment methods
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'طرق الدفع',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...paymentMethods.entries.map((entry) => ListTile(
                leading: const Icon(Icons.payment),
                title: Text(_getPaymentMethodName(entry.key)),
                trailing: Text('${entry.value} معاملة'),
              )),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildExpensesReport(ExpenseService expenseService) {
    final expenses = expenseService.getExpensesByDateRange(_startDate, _endDate);
    final totalExpenses = expenseService.getTotalExpensesByDateRange(_startDate, _endDate);
    final expensesByCategory = expenseService.getExpensesByCategory();

    return [
      // Summary cards
      Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'إجمالي المصروفات',
              '${totalExpenses.toStringAsFixed(2)} ريال',
              Icons.money_off,
              Colors.red,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildSummaryCard(
              'عدد المصروفات',
              '${expenses.length}',
              Icons.receipt_long,
              Colors.orange,
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      
      // Expenses by category
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'المصروفات حسب الفئة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...expensesByCategory.entries.map((entry) => ListTile(
                leading: const Icon(Icons.category),
                title: Text(entry.key),
                trailing: Text(
                  '${entry.value.toStringAsFixed(2)} ريال',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),
      
      // Recent expenses
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'آخر المصروفات',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...expenses.take(10).map((expense) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Text(
                    expense.category.substring(0, 1),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(expense.description),
                subtitle: Text(
                  '${expense.category} - ${expense.vendor}',
                ),
                trailing: Text(
                  '${expense.amount.toStringAsFixed(2)} ريال',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildInventoryReport(InventoryService inventoryService) {
    final lowStockItems = inventoryService.getLowStockItems();
    final outOfStockItems = inventoryService.getOutOfStockItems();
    final totalItems = inventoryService.inventory.length;

    return [
      // Summary cards
      Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'إجمالي المنتجات',
              '$totalItems',
              Icons.inventory,
              Colors.blue,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildSummaryCard(
              'مخزون منخفض',
              '${lowStockItems.length}',
              Icons.warning,
              Colors.orange,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildSummaryCard(
              'نفد المخزون',
              '${outOfStockItems.length}',
              Icons.error,
              Colors.red,
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      
      // Low stock items
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'منتجات المخزون المنخفض',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...lowStockItems.take(10).map((item) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: const Icon(Icons.trending_down, color: Colors.white),
                ),
                title: Text(item.productName),
                subtitle: Text(
                  'الكمية: ${item.quantity} | الحد الأدنى: ${item.minStock}',
                ),
                trailing: Text(
                  '${item.location}',
                  style: const TextStyle(fontSize: 12),
                ),
              )),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),
      
      // Out of stock items
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'منتجات نفد مخزونها',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...outOfStockItems.map((item) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.error, color: Colors.white),
                ),
                title: Text(item.productName),
                subtitle: Text('الموقع: ${item.location}'),
              )),
            ],
          ),
        ),
      ),
    ];
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPaymentMethodName(String method) {
    switch (method) {
      case 'cash':
        return 'نقدي';
      case 'card':
        return 'بطاقة ائتمان';
      case 'bank_transfer':
        return 'حوالة بنكية';
      default:
        return method;
    }
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
        title: const Text('التقارير'),
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
          final saleService = ref.watch(saleServiceProvider);
          final expenseService = ref.watch(expenseServiceProvider);
          final inventoryService = ref.watch(inventoryServiceProvider);
          
          return Column(
            children: [
              // Controls
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    DropdownButton<String>(
                      value: _selectedReport,
                      items: const [
                        DropdownMenuItem(value: 'المبيعات', child: Text('المبيعات')),
                        DropdownMenuItem(value: 'المصروفات', child: Text('المصروفات')),
                        DropdownMenuItem(value: 'المخزون', child: Text('المخزون')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedReport = value!;
                        });
                      },
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _selectDateRange,
                      icon: const Icon(Icons.date_range),
                      label: Text(
                        'من ${_startDate.day}/${_startDate.month} إلى ${_endDate.day}/${_endDate.month}',
                      ),
                    ),
                  ],
                ),
              ),
              
              // Report content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: () {
                      switch (_selectedReport) {
                        case 'المبيعات':
                          return _buildSalesReport(saleService);
                        case 'المصروفات':
                          return _buildExpensesReport(expenseService);
                        case 'المخزون':
                          return _buildInventoryReport(inventoryService);
                        default:
                          return _buildSalesReport(saleService);
                      }
                    }(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}