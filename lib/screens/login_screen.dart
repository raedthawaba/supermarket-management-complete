import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../constants/theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // محاكاة تسجيل الدخول
      await Future.delayed(const Duration(seconds: 2));
      
      // إذا نجح تسجيل الدخول
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تسجيل الدخول بنجاح!'),
            backgroundColor: AppColors.success,
          ),
        );
        
        // الانتقال إلى لوحة التحكم
        context.go('/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تسجيل الدخول: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _fillDemoCredentials() {
    _emailController.text = 'admin@supermarket.com';
    _passwordController.text = '123456';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
              AppColors.secondary,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 60.h),
                
                // شعار التطبيق
                _buildLogo(),
                SizedBox(height: 30.h),
                
                // عنوان الترحيب
                _buildWelcomeTitle(),
                SizedBox(height: 8.h),
                
                // وصف التطبيق
                _buildWelcomeSubtitle(),
                SizedBox(height: 40.h),
                
                // نموذج تسجيل الدخول
                _buildLoginCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 120.w,
      height: 120.w,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Icon(
        Icons.store,
        size: 60.w,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildWelcomeTitle() {
    return Text(
      'مرحباً بكم',
      style: AppTextStyles.headlineLarge.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildWelcomeSubtitle() {
    return Text(
      'نظام إدارة السوبر ماركت المتكامل',
      style: AppTextStyles.titleMedium.copyWith(
        color: Colors.white.withOpacity(0.9),
        fontWeight: FontWeight.normal,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildLoginCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'تسجيل الدخول',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            
            Text(
              'أدخل بياناتك للوصول إلى النظام',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // حقل البريد الإلكتروني
                  CustomTextField(
                    controller: _emailController,
                    label: 'البريد الإلكتروني',
                    hint: 'أدخل بريدك الإلكتروني',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'يرجى إدخال البريد الإلكتروني';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'يرجى إدخال بريد إلكتروني صحيح';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  
                  // حقل كلمة المرور
                  CustomTextField(
                    controller: _passwordController,
                    label: 'كلمة المرور',
                    hint: 'أدخل كلمة المرور',
                    prefixIcon: Icons.lock_outline,
                    obscureText: !_isPasswordVisible,
                    suffixIcon: _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    onSuffixPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال كلمة المرور';
                      }
                      if (value.length < 6) {
                        return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            
            // زر تسجيل الدخول
            CustomButton(
              text: _isLoading ? 'جاري تسجيل الدخول...' : 'تسجيل الدخول',
              onPressed: _isLoading ? null : _login,
              isLoading: _isLoading,
            ),
            SizedBox(height: 16.h),
            
            // بيانات تجريبية
            _buildDemoCredentials(),
            SizedBox(height: 16.h),
            
            // رابط نسيان كلمة المرور
            _buildForgotPassword(),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoCredentials() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.info.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.info,
            size: 20.w,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'بيانات تجريبية',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.info,
                  ),
                ),
                Text(
                  'admin@supermarket.com / 123456',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.info,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _fillDemoCredentials,
            child: Text(
              'ملء تلقائي',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.info,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Center(
      child: TextButton(
        onPressed: () {
          // TODO: تنفيذ نسيان كلمة المرور
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('سيتم تنفيذ هذه الميزة قريباً'),
            ),
          );
        },
        child: Text(
          'نسيت كلمة المرور؟',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}