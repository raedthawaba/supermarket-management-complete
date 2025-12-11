import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'constants/theme.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/pos_screen.dart';
import 'screens/products_screen.dart';
import 'screens/inventory_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/expenses_screen.dart';

import 'services/auth_service.dart';
import 'services/product_service.dart';
import 'services/sale_service.dart';
import 'services/inventory_service.dart';
import 'services/expense_service.dart';

// ============================================
// Providers
// ============================================
final authServiceProvider = ChangeNotifierProvider<AuthService>((ref) => AuthService());
final productServiceProvider = ChangeNotifierProvider<ProductService>((ref) => ProductService());
final saleServiceProvider = ChangeNotifierProvider<SaleService>((ref) => SaleService());
final inventoryServiceProvider = ChangeNotifierProvider<InventoryService>((ref) => InventoryService());
final expenseServiceProvider = ChangeNotifierProvider<ExpenseService>((ref) => ExpenseService());

// ============================================
// Main Application
// ============================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize shared preferences
  final prefs = await SharedPreferences.getInstance();
  
  // Run the app with Riverpod
  runApp(ProviderScope(
    child: MyApp(preferences: prefs),
  ));
}

// ============================================
// Main App Widget
// ============================================
class MyApp extends StatelessWidget {
  final SharedPreferences preferences;

  const MyApp({
    super.key,
    required this.preferences,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'نظام إدارة السوبر ماركت',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          locale: const Locale('ar', 'SA'),
          supportedLocales: const [
            Locale('ar', 'SA'), // العربية - السعودية
            Locale('ar', 'AE'), // العربية - الإمارات
            Locale('ar', 'EG'), // العربية - مصر
            Locale('ar', 'YE'), // العربية - اليمن
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: GoRouter(
            initialLocation: '/login',
            redirect: (context, state) {
              // TODO: Add authentication check
              // For now, we'll allow all routes
              return null;
            },
            routes: [
              // شاشة تسجيل الدخول
              GoRoute(
                path: '/login',
                name: 'login',
                builder: (context, state) => const LoginScreen(),
              ),
              
              // لوحة التحكم الرئيسية
              GoRoute(
                path: '/dashboard',
                name: 'dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
              
              // نقطة البيع
              GoRoute(
                path: '/pos',
                name: 'pos',
                builder: (context, state) => const POSScreen(),
              ),
              
              // صفحات المنتجات
              GoRoute(
                path: '/products',
                name: 'products',
                builder: (context, state) => const ProductsScreen(),
              ),
              
              // صفحات المخزون
              GoRoute(
                path: '/inventory',
                name: 'inventory',
                builder: (context, state) => const InventoryScreen(),
              ),
              
              // صفحات المصروفات
              GoRoute(
                path: '/expenses',
                name: 'expenses',
                builder: (context, state) => const ExpensesScreen(),
              ),
              
              // صفحات التقارير
              GoRoute(
                path: '/reports',
                name: 'reports',
                builder: (context, state) => const ReportsScreen(),
              ),
              
              // صفحة الخطأ 404
              GoRoute(
                path: '/404',
                name: 'notFound',
                builder: (context, state) => const PlaceholderScreen(
                  title: 'الصفحة غير موجودة',
                  subtitle: 'عذراً، الصفحة التي تبحث عنها غير موجودة',
                  icon: Icons.error_outline,
                ),
              ),
            ],
            errorBuilder: (context, state) => const PlaceholderScreen(
              title: 'خطأ في التنقل',
              subtitle: 'حدث خطأ في التنقل',
              icon: Icons.error,
            ),
          ),
        );
      },
    );
  }
}

// ============================================
// Placeholder Screen for Development
// ============================================
class PlaceholderScreen extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;

  const PlaceholderScreen({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80.w,
              color: AppColors.primary,
            ),
            SizedBox(height: 24.h),
            Text(
              title,
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              SizedBox(height: 8.h),
              Text(
                subtitle!,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            SizedBox(height: 32.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.warning.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.construction,
                    color: AppColors.warning,
                    size: 32.w,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'هذه الصفحة قيد التطوير',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'سيتم تطوير هذه الصفحة في الإصدار القادم',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}