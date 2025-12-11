// نماذج البيانات الأساسية لنظام إدارة السوبر ماركت

// ============================================
// 1. نموذج المستخدم
// ============================================
class User {
  final String id;
  final String name;
  final String email;
  final String username;
  final UserRole role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final String? phone;
  final String? avatar;
  final List<String> permissions;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.role,
    this.isActive = true,
    required this.createdAt,
    this.lastLogin,
    this.phone,
    this.avatar,
    List<String>? permissions,
  }) : permissions = permissions ?? [];

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? username,
    UserRole? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastLogin,
    String? phone,
    String? avatar,
    List<String>? permissions,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      username: username ?? this.username,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      permissions: permissions ?? this.permissions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'username': username,
      'role': role.name,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
      'phone': phone,
      'avatar': avatar,
      'permissions': permissions,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      username: json['username'],
      role: UserRole.values.firstWhere((e) => e.name == json['role']),
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      lastLogin: json['lastLogin'] != null 
          ? DateTime.parse(json['lastLogin']) 
          : null,
      phone: json['phone'],
      avatar: json['avatar'],
      permissions: List<String>.from(json['permissions'] ?? []),
    );
  }
}

enum UserRole {
  admin,
  manager,
  cashier,
  inventoryManager,
  accountant,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'مدير عام';
      case UserRole.manager:
        return 'مدير';
      case UserRole.cashier:
        return 'كاشير';
      case UserRole.inventoryManager:
        return 'مدير مخزون';
      case UserRole.accountant:
        return 'محاسب';
    }
  }

  String get description {
    switch (this) {
      case UserRole.admin:
        return 'لديه صلاحيات كاملة في النظام';
      case UserRole.manager:
        return 'إدارة العمليات اليومية';
      case UserRole.cashier:
        return 'تسجيل المبيعات والمعاملات';
      case UserRole.inventoryManager:
        return 'إدارة المخزون والمنتجات';
      case UserRole.accountant:
        return 'إدارة الحسابات والتقارير المالية';
    }
  }

  List<String> get permissions {
    switch (this) {
      case UserRole.admin:
        return ['*']; // جميع الصلاحيات
      case UserRole.manager:
        return ['manage_users', 'view_reports', 'manage_products', 'manage_sales'];
      case UserRole.cashier:
        return ['process_sales', 'view_inventory'];
      case UserRole.inventoryManager:
        return ['manage_products', 'view_reports', 'manage_purchases'];
      case UserRole.accountant:
        return ['view_reports', 'manage_expenses', 'manage_bank_accounts'];
    }
  }
}

// ============================================
// 2. نموذج المنتج
// ============================================
class Product {
  final String id;
  final String name;
  final String? description;
  final String barcode;
  final String category;
  final double costPrice;
  final double sellingPrice;
  final int stockQuantity;
  final int minStockLevel;
  final String? image;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? expiryDate;
  final String? supplier;
  final String unit;
  final double? weight;
  final String? brand;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.barcode,
    required this.category,
    required this.costPrice,
    required this.sellingPrice,
    required this.stockQuantity,
    required this.minStockLevel,
    this.image,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.expiryDate,
    this.supplier,
    this.unit = 'piece',
    this.weight,
    this.brand,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? barcode,
    String? category,
    double? costPrice,
    double? sellingPrice,
    int? stockQuantity,
    int? minStockLevel,
    String? image,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? expiryDate,
    String? supplier,
    String? unit,
    double? weight,
    String? brand,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      barcode: barcode ?? this.barcode,
      category: category ?? this.category,
      costPrice: costPrice ?? this.costPrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      minStockLevel: minStockLevel ?? this.minStockLevel,
      image: image ?? this.image,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      expiryDate: expiryDate ?? this.expiryDate,
      supplier: supplier ?? this.supplier,
      unit: unit ?? this.unit,
      weight: weight ?? this.weight,
      brand: brand ?? this.brand,
    );
  }

  double get profitMargin => sellingPrice - costPrice;
  double get profitPercentage => costPrice > 0 
      ? ((sellingPrice - costPrice) / costPrice) * 100 
      : 0;
  
  bool get isLowStock => stockQuantity <= minStockLevel;
  bool get isOutOfStock => stockQuantity <= 0;
  bool get isExpiring => expiryDate != null 
      ? DateTime.now().isAfter(expiryDate!) 
      : false;
  bool get isNearExpiry => expiryDate != null 
      ? DateTime.now().isAfter(expiryDate!.subtract(const Duration(days: 7))) 
      : false;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'barcode': barcode,
      'category': category,
      'costPrice': costPrice,
      'sellingPrice': sellingPrice,
      'stockQuantity': stockQuantity,
      'minStockLevel': minStockLevel,
      'image': image,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'supplier': supplier,
      'unit': unit,
      'weight': weight,
      'brand': brand,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      barcode: json['barcode'],
      category: json['category'],
      costPrice: (json['costPrice'] as num).toDouble(),
      sellingPrice: (json['sellingPrice'] as num).toDouble(),
      stockQuantity: json['stockQuantity'],
      minStockLevel: json['minStockLevel'],
      image: json['image'],
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      expiryDate: json['expiryDate'] != null 
          ? DateTime.parse(json['expiryDate']) 
          : null,
      supplier: json['supplier'],
      unit: json['unit'] ?? 'piece',
      weight: json['weight']?.toDouble(),
      brand: json['brand'],
    );
  }
}

// ============================================
// 3. نموذج المبيعات
// ============================================
class Sale {
  final String id;
  final String invoiceNumber;
  final String cashierId;
  final String cashierName;
  final List<SaleItem> items;
  final double subtotal;
  final double tax;
  final double discount;
  final double totalAmount;
  final PaymentMethod paymentMethod;
  final SaleStatus status;
  final DateTime saleDate;
  final String? customerName;
  final String? customerPhone;
  final String? notes;

  Sale({
    required this.id,
    required this.invoiceNumber,
    required this.cashierId,
    required this.cashierName,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.totalAmount,
    required this.paymentMethod,
    required this.status,
    required this.saleDate,
    this.customerName,
    this.customerPhone,
    this.notes,
  });

  double get profit {
    return items.fold(0.0, (sum, item) => 
        sum + ((item.product.sellingPrice - item.product.costPrice) * item.quantity));
  }

  double get profitPercentage {
    return subtotal > 0 ? (profit / subtotal) * 100 : 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoiceNumber': invoiceNumber,
      'cashierId': cashierId,
      'cashierName': cashierName,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'discount': discount,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod.name,
      'status': status.name,
      'saleDate': saleDate.toIso8601String(),
      'customerName': customerName,
      'customerPhone': customerPhone,
      'notes': notes,
    };
  }

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'],
      invoiceNumber: json['invoiceNumber'],
      cashierId: json['cashierId'],
      cashierName: json['cashierName'],
      items: (json['items'] as List)
          .map((item) => SaleItem.fromJson(item))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.name == json['paymentMethod']
      ),
      status: SaleStatus.values.firstWhere(
        (e) => e.name == json['status']
      ),
      saleDate: DateTime.parse(json['saleDate']),
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      notes: json['notes'],
    );
  }
}

class SaleItem {
  final String id;
  final Product product;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  SaleItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
    };
  }

  factory SaleItem.fromJson(Map<String, dynamic> json) {
    return SaleItem(
      id: json['id'],
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      unitPrice: (json['unitPrice'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );
  }
}

enum PaymentMethod {
  cash,
  card,
  bankTransfer,
  digitalWallet,
  credit,
}

enum SaleStatus {
  completed,
  pending,
  cancelled,
  refunded,
}

// ============================================
// 4. نموذج المصروفات
// ============================================
class Expense {
  final String id;
  final String title;
  final String description;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;
  final ExpenseStatus status;
  final String? receipt;
  final String? vendor;
  final String? approvedBy;
  final DateTime? approvedAt;
  final String? notes;

  Expense({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
    required this.status,
    this.receipt,
    this.vendor,
    this.approvedBy,
    this.approvedAt,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'category': category.name,
      'date': date.toIso8601String(),
      'status': status.name,
      'receipt': receipt,
      'vendor': vendor,
      'approvedBy': approvedBy,
      'approvedAt': approvedAt?.toIso8601String(),
      'notes': notes,
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      amount: (json['amount'] as num).toDouble(),
      category: ExpenseCategory.values.firstWhere(
        (e) => e.name == json['category']
      ),
      date: DateTime.parse(json['date']),
      status: ExpenseStatus.values.firstWhere(
        (e) => e.name == json['status']
      ),
      receipt: json['receipt'],
      vendor: json['vendor'],
      approvedBy: json['approvedBy'],
      approvedAt: json['approvedAt'] != null 
          ? DateTime.parse(json['approvedAt']) 
          : null,
      notes: json['notes'],
    );
  }
}

enum ExpenseCategory {
  utilities,
  rent,
  salaries,
  inventory,
  marketing,
  maintenance,
  transportation,
  office,
  other,
}

enum ExpenseStatus {
  pending,
  approved,
  rejected,
  paid,
}

// ============================================
// 5. نموذج التقارير
// ============================================
class DailyReport {
  final String id;
  final String cashierId;
  final String cashierName;
  final DateTime date;
  final double totalSales;
  final double totalExpenses;
  final double netProfit;
  final int totalTransactions;
  final Map<String, double> paymentMethodBreakdown;
  final List<String> topSellingProducts;
  final double cashInHand;
  final double bankDeposits;
  final String? notes;
  final bool isSubmitted;
  final bool isApproved;
  final DateTime? submittedAt;
  final DateTime? approvedAt;
  final String? submittedBy;
  final String? approvedBy;

  DailyReport({
    required this.id,
    required this.cashierId,
    required this.cashierName,
    required this.date,
    required this.totalSales,
    required this.totalExpenses,
    required this.netProfit,
    required this.totalTransactions,
    required this.paymentMethodBreakdown,
    required this.topSellingProducts,
    required this.cashInHand,
    required this.bankDeposits,
    this.notes,
    this.isSubmitted = false,
    this.isApproved = false,
    this.submittedAt,
    this.approvedAt,
    this.submittedBy,
    this.approvedBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cashierId': cashierId,
      'cashierName': cashierName,
      'date': date.toIso8601String(),
      'totalSales': totalSales,
      'totalExpenses': totalExpenses,
      'netProfit': netProfit,
      'totalTransactions': totalTransactions,
      'paymentMethodBreakdown': paymentMethodBreakdown,
      'topSellingProducts': topSellingProducts,
      'cashInHand': cashInHand,
      'bankDeposits': bankDeposits,
      'notes': notes,
      'isSubmitted': isSubmitted,
      'isApproved': isApproved,
      'submittedAt': submittedAt?.toIso8601String(),
      'approvedAt': approvedAt?.toIso8601String(),
      'submittedBy': submittedBy,
      'approvedBy': approvedBy,
    };
  }

  factory DailyReport.fromJson(Map<String, dynamic> json) {
    return DailyReport(
      id: json['id'],
      cashierId: json['cashierId'],
      cashierName: json['cashierName'],
      date: DateTime.parse(json['date']),
      totalSales: (json['totalSales'] as num).toDouble(),
      totalExpenses: (json['totalExpenses'] as num).toDouble(),
      netProfit: (json['netProfit'] as num).toDouble(),
      totalTransactions: json['totalTransactions'],
      paymentMethodBreakdown: Map<String, double>.from(
        json['paymentMethodBreakdown'].map((key, value) => 
            MapEntry(key, (value as num).toDouble()))
      ),
      topSellingProducts: List<String>.from(json['topSellingProducts']),
      cashInHand: (json['cashInHand'] as num).toDouble(),
      bankDeposits: (json['bankDeposits'] as num).toDouble(),
      notes: json['notes'],
      isSubmitted: json['isSubmitted'] ?? false,
      isApproved: json['isApproved'] ?? false,
      submittedAt: json['submittedAt'] != null 
          ? DateTime.parse(json['submittedAt']) 
          : null,
      approvedAt: json['approvedAt'] != null 
          ? DateTime.parse(json['approvedAt']) 
          : null,
      submittedBy: json['submittedBy'],
      approvedBy: json['approvedBy'],
    );
  }
}