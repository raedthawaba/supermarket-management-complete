import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/expense_service.dart';
import '../widgets/custom_widgets.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'الكل';
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    final expenseService = ref.read(expenseServiceProvider);
    await expenseService.init();
    await expenseService.createSampleExpenses();
    setState(() {
      _isInitialized = true;
    });
  }

  void _showAddEditExpenseDialog({Expense? expense}) {
    final descriptionController = TextEditingController(text: expense?.description ?? '');
    final amountController = TextEditingController(text: expense?.amount.toString() ?? '');
    final categoryController = TextEditingController(text: expense?.category ?? '');
    final vendorController = TextEditingController(text: expense?.vendor ?? '');
    String paymentMethod = expense?.paymentMethod ?? 'cash';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(expense == null ? 'إضافة مصروف' : 'تعديل مصروف'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'الوصف *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'المبلغ *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: paymentMethod,
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
                          paymentMethod = value!;
                        });
                      },
                    ),
                  ),
                ],
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
              TextField(
                controller: vendorController,
                decoration: const InputDecoration(
                  labelText: 'المورد *',
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
              if (descriptionController.text.isEmpty ||
                  amountController.text.isEmpty ||
                  categoryController.text.isEmpty ||
                  vendorController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('يرجى ملء جميع الحقول المطلوبة')),
                );
                return;
              }

              try {
                final newExpense = Expense(
                  id: expense?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  description: descriptionController.text,
                  amount: double.parse(amountController.text),
                  category: categoryController.text,
                  vendor: vendorController.text,
                  paymentMethod: paymentMethod,
                  timestamp: expense?.timestamp ?? DateTime.now(),
                  userId: expense?.userId ?? '',
                );

                final expenseService = ref.read(expenseServiceProvider);
                if (expense == null) {
                  await expenseService.addExpense(newExpense);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم إضافة المصروف بنجاح')),
                  );
                } else {
                  await expenseService.updateExpense(newExpense);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم تعديل المصروف بنجاح')),
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

  void _deleteExpense(Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المصروف'),
        content: Text('هل أنت متأكد من حذف "${expense.description}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final expenseService = ref.read(expenseServiceProvider);
              await expenseService.deleteExpense(expense.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حذف المصروف بنجاح')),
              );
            },
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  List<String> getCategories(List<Expense> expenses) {
    return expenses.map((e) => e.category).toSet().toList();
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
        title: const Text('إدارة المصروفات'),
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
          final expenseService = ref.watch(expenseServiceProvider);
          
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
                          hintText: 'البحث في المصروفات...',
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
                        ...getCategories(expenseService.expenses).map((category) {
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
                      onPressed: () => _showAddEditExpenseDialog(),
                      icon: const Icon(Icons.add),
                      label: const Text('إضافة مصروف'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    ),
                  ],
                ),
              ),
              
              // Summary cards
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const Text('مصروفات اليوم'),
                              Text(
                                '${expenseService.getTodaysTotalExpenses().toStringAsFixed(2)} ريال',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const Text('عدد المصروفات'),
                              Text(
                                '${expenseService.getTodaysExpenses().length}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Expenses list
              Expanded(
                child: ListView.builder(
                  itemCount: expenseService.expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenseService.expenses[index];
                    
                    // Apply filters
                    if (_searchController.text.isNotEmpty &&
                        !expenseService.searchExpenses(_searchController.text).contains(expense)) {
                      return const SizedBox.shrink();
                    }
                    
                    if (_selectedCategory != 'الكل' && expense.category != _selectedCategory) {
                      return const SizedBox.shrink();
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.red,
                          child: Text(
                            expense.category.substring(0, 1),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          expense.description,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('المورد: ${expense.vendor}'),
                            Text('الفئة: ${expense.category}'),
                            Text(
                              expense.timestamp.toLocal().toString().split(' ')[0],
                            ),
                            Text('طريقة الدفع: ${_getPaymentMethodName(expense.paymentMethod)}'),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${expense.amount.toStringAsFixed(2)} ريال',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      _showAddEditExpenseDialog(expense: expense),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteExpense(expense),
                                ),
                              ],
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
        onPressed: () => _showAddEditExpenseDialog(),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}