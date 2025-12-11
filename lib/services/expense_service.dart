import 'package:flutter/material.dart';
import '../models/models.dart';
import 'storage_service.dart';

class ExpenseService extends ChangeNotifier {
  List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;

  Future<void> init() async {
    await StorageService.init();
    await loadExpenses();
  }

  Future<void> loadExpenses() async {
    final expensesData = StorageService.getExpenses();
    _expenses = expensesData.map((expenseData) => Expense.fromJson(expenseData)).toList();
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    _expenses.add(expense);
    await _saveExpenses();
    notifyListeners();
  }

  Future<void> updateExpense(Expense updatedExpense) async {
    final index = _expenses.indexWhere((expense) => expense.id == updatedExpense.id);
    if (index != -1) {
      _expenses[index] = updatedExpense;
      await _saveExpenses();
      notifyListeners();
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    _expenses.removeWhere((expense) => expense.id == expenseId);
    await _saveExpenses();
    notifyListeners();
  }

  Future<void> _saveExpenses() async {
    final expensesJson = _expenses.map((expense) => expense.toJson()).toList();
    await StorageService.saveExpenses(expensesJson);
  }

  List<Expense> getExpensesByDateRange(DateTime start, DateTime end) {
    return _expenses.where((expense) {
      return expense.timestamp.isAfter(start) && expense.timestamp.isBefore(end);
    }).toList();
  }

  double getTotalExpensesByDateRange(DateTime start, DateTime end) {
    return getExpensesByDateRange(start, end).fold(0.0, (sum, expense) => sum + expense.amount);
  }

  List<Expense> getTodaysExpenses() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return getExpensesByDateRange(startOfDay, endOfDay);
  }

  double getTodaysTotalExpenses() {
    return getTodaysExpenses().fold(0.0, (sum, expense) => sum + expense.amount);
  }

  Map<String, double> getExpensesByCategory() {
    final Map<String, double> categoryTotals = {};
    
    for (final expense in _expenses) {
      categoryTotals[expense.category] = 
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }
    
    return categoryTotals;
  }

  Map<String, double> getExpensesByDate(int days) {
    final Map<String, double> expensesByDate = {};
    final now = DateTime.now();
    
    for (int i = days - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayStart = DateTime(date.year, date.month, date.day);
      final dayEnd = dayStart.add(const Duration(days: 1));
      
      final dayExpenses = getExpensesByDateRange(dayStart, dayEnd);
      final dayTotal = dayExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
      
      expensesByDate[dayStart.toIso8601String().split('T')[0]] = dayTotal;
    }
    
    return expensesByDate;
  }

  List<Expense> searchExpenses(String query) {
    if (query.isEmpty) return _expenses;
    
    return _expenses.where((expense) {
      return expense.description.toLowerCase().contains(query.toLowerCase()) ||
             expense.category.toLowerCase().contains(query.toLowerCase()) ||
             expense.vendor.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  Future<void> createSampleExpenses() async {
    if (_expenses.isNotEmpty) return;

    final sampleExpenses = [
      Expense(
        id: '1',
        description: 'فاتورة الكهرباء',
        amount: 500.00,
        category: 'المرافق',
        vendor: 'شركة الكهرباء',
        paymentMethod: 'bank_transfer',
        timestamp: DateTime.now(),
        userId: '1',
      ),
      Expense(
        id: '2',
        description: 'توريد منتجات طازجة',
        amount: 2000.00,
        category: 'توريد البضائع',
        vendor: 'مزود المنتجات',
        paymentMethod: 'cash',
        timestamp: DateTime.now(),
        userId: '1',
      ),
      Expense(
        id: '3',
        description: 'راتب موظف',
        amount: 3000.00,
        category: 'رواتب',
        vendor: 'موظف المبيعات',
        paymentMethod: 'bank_transfer',
        timestamp: DateTime.now(),
        userId: '1',
      ),
    ];

    for (final expense in sampleExpenses) {
      await addExpense(expense);
    }
  }
}