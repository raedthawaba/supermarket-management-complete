import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../constants/theme.dart';
import '../widgets/custom_widgets.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // شريط التطبيق العلوي
          _buildAppBar(),
          
          // محتوى الصفحة
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: [
                // الصفحة الرئيسية
                _buildHomeTab(),
                // صفحة المنتجات
                _buildProductsTab(),
                // صفحة المبيعات
                _buildSalesTab(),
                // صفحة التقارير
                _buildReportsTab(),
                // صفحة الملف الشخصي
                _buildProfileTab(),
              ],
            ),
          ),
        ],
      ),
      
      // شريط التنقل السفلي
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // صف العنوان
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مرحباً',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      Text(
                        'أحمد محمد',
                        style: AppTextStyles.titleLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // صورة المستخدم
                GestureDetector(
                  onTap: () {
                    context.go('/profile');
                  },
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20.w,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            
            // شريط البحث
            CustomSearchBar(
              hint: 'البحث في المنتجات...',
              onChanged: (value) {
                // TODO: تنفيذ البحث
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    final items = [
      {'icon': Icons.home, 'label': 'الرئيسية'},
      {'icon': Icons.inventory_2, 'label':      {'icon': 'المنتجات'},
 Icons.point_of_sale, 'label': 'المبيعات'},
      {'icon': Icons.analytics, 'label': 'التقارير'},
      {'icon': Icons.person, 'label': 'الملف الشخصي'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: AppTextStyles.labelSmall,
        unselectedLabelStyle: AppTextStyles.labelSmall,
        items: items.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item['icon'] as IconData),
            activeIcon: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                item['icon'] as IconData,
                color: AppColors.primary,
                size: 20.w,
              ),
            ),
            label: item['label'] as String,
          );
        }).toList(),
      ),
    );
  }

  // ============================================
  // تبويب الصفحة الرئيسية
  // ============================================
  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // إحصائيات سريعة
          _buildQuickStats(),
          SizedBox(height: 24.h),
          
          // العمليات السريعة
          _buildQuickActions(),
          SizedBox(height: 24.h),
          
          // المبيعات الحديثة
          _buildRecentSales(),
          SizedBox(height: 24.h),
          
          // المنتجات قليلة المخزون
          _buildLowStockProducts(),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نظرة عامة',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.attach_money,
                title: 'المبيعات اليوم',
                value: '15,420 ر.س',
                change: '+12%',
                isPositive: true,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: StatCard(
                icon: Icons.inventory,
                title: 'المنتجات',
                value: '1,247',
                change: '-2%',
                isPositive: false,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.people,
                title: 'العملاء',
                value: '89',
                change: '+5%',
                isPositive: true,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: StatCard(
                icon: Icons.trending_up,
                title: 'الربح',
                value: '2,340 ر.س',
                change: '+8%',
                isPositive: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'icon': Icons.point_of_sale, 'label': 'نقطة البيع', 'color': AppColors.success},
      {'icon': Icons.add_box, 'label': 'إضافة منتج', 'color': AppColors.primary},
      {'icon': Icons.shopping_cart, 'label': 'المشتريات', 'color': AppColors.warning},
      {'icon': Icons.receipt, 'label': 'إنهاء اليومية', 'color': AppColors.info},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'العمليات السريعة',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.w,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return CustomCard(
              onTap: () {
                // TODO: تنفيذ العمليات
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: (action['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      action['icon'] as IconData,
                      color: action['color'] as Color,
                      size: 24.w,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    action['label'] as String,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentSales() {
    final recentSales = [
      {'id': '#INV001', 'customer': 'أحمد محمد', 'amount': '125.50 ر.س', 'time': '10:30'},
      {'id': '#INV002', 'customer': 'فاطمة علي', 'amount': '89.25 ر.س', 'time': '11:15'},
      {'id': '#INV003', 'customer': 'محمد أحمد', 'amount': '245.75 ر.س', 'time': '11:45'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'المبيعات الحديثة',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                context.go('/sales');
              },
              child: Text(
                'عرض الكل',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentSales.length,
          itemBuilder: (context, index) {
            final sale = recentSales[index];
            return CustomCard(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.receipt,
                      color: AppColors.success,
                      size: 20.w,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sale['id'] as String,
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          sale['customer'] as String,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        sale['amount'] as String,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        sale['time'] as String,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLowStockProducts() {
    final lowStockProducts = [
      {'name': 'حليب طازج', 'stock': 5, 'min': 10},
      {'name': 'خبز أبيض', 'stock': 3, 'min': 20},
      {'name': 'بيض طازج', 'stock': 8, 'min': 30},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'منتجات قليلة المخزون',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                context.go('/inventory');
              },
              child: Text(
                'عرض الكل',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: lowStockProducts.length,
          itemBuilder: (context, index) {
            final product = lowStockProducts[index];
            final stock = product['stock'] as int;
            final minStock = product['min'] as int;
            final percentage = (stock / minStock) * 100;

            return CustomCard(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.warning,
                      color: AppColors.warning,
                      size: 20.w,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'] as String,
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Container(
                          width: double.infinity,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: AppColors.divider,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                width: (percentage * 2).w,
                                decoration: BoxDecoration(
                                  color: AppColors.warning,
                                  borderRadius: BorderRadius.circular(2.r),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '$stock من $minStock',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // ============================================
  // باقي التبويبات
  // ============================================
  Widget _buildProductsTab() {
    return const Center(
      child: EmptyStateWidget(
        icon: Icons.inventory_2,
        title: 'صفحة المنتجات',
        subtitle: 'سيتم تطوير هذه الصفحة قريباً',
      ),
    );
  }

  Widget _buildSalesTab() {
    return const Center(
      child: EmptyStateWidget(
        icon: Icons.point_of_sale,
        title: 'صفحة المبيعات',
        subtitle: 'سيتم تطوير هذه الصفحة قريباً',
      ),
    );
  }

  Widget _buildReportsTab() {
    return const Center(
      child: EmptyStateWidget(
        icon: Icons.analytics,
        title: 'صفحة التقارير',
        subtitle: 'سيتم تطوير هذه الصفحة قريباً',
      ),
    );
  }

  Widget _buildProfileTab() {
    return const Center(
      child: EmptyStateWidget(
        icon: Icons.person,
        title: 'الملف الشخصي',
        subtitle: 'سيتم تطوير هذه الصفحة قريباً',
      ),
    );
  }
}