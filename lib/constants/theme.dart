import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

// ============================================
// الثيم الرئيسي للتطبيق
// ============================================

class AppTheme {
  // الألوان الأساسية
  static const Color primary = Color(0xFF2196F3); // أزرق أساسي
  static const Color primaryLight = Color(0xFF64B5F6); // أزرق فاتح
  static const Color primaryDark = Color(0xFF1976D2); // أزرق داكن
  static const Color secondary = Color(0xFF4CAF50); // أخضر ثانوي
  static const Color secondaryLight = Color(0xFF81C784); // أخضر فاتح
  static const Color secondaryDark = Color(0xFF388E3C); // أخضر داكن

  // ألوان الحالة
  static const Color success = Color(0xFF4CAF50); // أخضر للنجاح
  static const Color warning = Color(0xFFFF9800); // برتقالي للتحذير
  static const Color error = Color(0xFFF44336); // أحمر للخطأ
  static const Color info = Color(0xFF2196F3); // أزرق للمعلومات

  // ألوان الخلفية
  static const Color background = Color(0xFFF8F9FA); // خلفية فاتحة
  static const Color surface = Color(0xFFFFFFFF); // سطح البطاقات
  static const Color surfaceVariant = Color(0xFFF5F5F5); // سطح بديل
  static const Color onSurface = Color(0xFF1C1B1F); // نص على السطح
  static const Color onSurfaceVariant = Color(0xFF757575); // نص بديل

  // ألوان النص
  static const Color textPrimary = Color(0xFF212121); // نص أساسي
  static const Color textSecondary = Color(0xFF757575); // نص ثانوي
  static const Color textHint = Color(0xFFBDBDBD); // نص تلميح
  static const Color textDisabled = Color(0xFFE0E0E0); // نص معطل

  // ألوان متقدمة
  static const Color cardShadow = Color(0x1A000000); // ظل البطاقات
  static const Color divider = Color(0xFFE0E0E0); // فواصل
  static const Color overlay = Color(0x80000000); // طبقة علوية

  // ألوان مخصصة للتطبيق
  static const Color gold = Color(0xFFFFD700); // ذهبي
  static const Color purple = Color(0xFF9C27B0); // بنفسجي
  static const Color pink = Color(0xFFE91E63); // وردي
  static const Color teal = Color(0xFF009688); // سماوي
  static const Color indigo = Color(0xFF3F51B5); // نيلي

  // ألوان متدرجة للخلفيات
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [background, surface],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ============================================
  // الثيم الفاتح
  // ============================================
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        tertiary: purple,
        error: error,
        surface: surface,
        background: background,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onBackground: textPrimary,
      ),
      
      // أنماط النصوص
      textTheme: _buildTextTheme(false),
      appBarTheme: _buildAppBarTheme(),
      cardTheme: _buildCardTheme(),
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      outlinedButtonTheme: _buildOutlinedButtonTheme(),
      textButtonTheme: _buildTextButtonTheme(),
      inputDecorationTheme: _buildInputDecorationTheme(),
      bottomNavigationBarTheme: _buildBottomNavigationBarTheme(),
      snackBarTheme: _buildSnackBarTheme(),
      progressIndicatorTheme: _buildProgressIndicatorTheme(),
      floatingActionButtonTheme: _buildFABTheme(),
      drawerTheme: _buildDrawerTheme(),
      listTileTheme: _buildListTileTheme(),
      switchTheme: _buildSwitchTheme(),
      checkboxTheme: _buildCheckboxTheme(),
      radioTheme: _buildRadioTheme(),
      iconTheme: _buildIconTheme(),
      primaryIconTheme: _buildPrimaryIconTheme(),
    );
  }

  // ============================================
  // الثيم الداكن
  // ============================================
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: const Color(0xFF121212),
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        tertiary: purple,
        error: error,
        surface: const Color(0xFF1E1E1E),
        background: const Color(0xFF121212),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
      ),
      
      // أنماط النصوص
      textTheme: _buildTextTheme(true),
      appBarTheme: _buildDarkAppBarTheme(),
      cardTheme: _buildDarkCardTheme(),
      elevatedButtonTheme: _buildElevatedButtonTheme(isDark: true),
      outlinedButtonTheme: _buildOutlinedButtonTheme(isDark: true),
      textButtonTheme: _buildTextButtonTheme(isDark: true),
      inputDecorationTheme: _buildInputDecorationTheme(isDark: true),
      bottomNavigationBarTheme: _buildBottomNavigationBarTheme(isDark: true),
      snackBarTheme: _buildSnackBarTheme(isDark: true),
      progressIndicatorTheme: _buildProgressIndicatorTheme(isDark: true),
      floatingActionButtonTheme: _buildFABTheme(isDark: true),
      drawerTheme: _buildDrawerTheme(isDark: true),
      listTileTheme: _buildListTileTheme(isDark: true),
      switchTheme: _buildSwitchTheme(isDark: true),
      checkboxTheme: _buildCheckboxTheme(isDark: true),
      radioTheme: _buildRadioTheme(isDark: true),
      iconTheme: _buildIconTheme(isDark: true),
      primaryIconTheme: _buildPrimaryIconTheme(isDark: true),
    );
  }

  // ============================================
  // دوال بناء الثيم
  // ============================================

  static TextTheme _buildTextTheme(bool isDark) {
    final baseTextColor = isDark ? Colors.white : textPrimary;
    final secondaryTextColor = isDark ? const Color(0xFFB0B0B0) : textSecondary;

    return TextTheme(
      // عناوين كبيرة
      displayLarge: GoogleFonts.cairo(
        fontSize: 57.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25.sp,
        color: baseTextColor,
      ),
      displayMedium: GoogleFonts.cairo(
        fontSize: 45.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.sp,
        color: baseTextColor,
      ),
      displaySmall: GoogleFonts.cairo(
        fontSize: 36.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.sp,
        color: baseTextColor,
      ),

      // عناوين
      headlineLarge: GoogleFonts.cairo(
        fontSize: 32.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.sp,
        color: baseTextColor,
      ),
      headlineMedium: GoogleFonts.cairo(
        fontSize: 28.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.sp,
        color: baseTextColor,
      ),
      headlineSmall: GoogleFonts.cairo(
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.sp,
        color: baseTextColor,
      ),

      // عناوين متوسطة
      titleLarge: GoogleFonts.cairo(
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.sp,
        color: baseTextColor,
      ),
      titleMedium: GoogleFonts.cairo(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15.sp,
        color: baseTextColor,
      ),
      titleSmall: GoogleFonts.cairo(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1.sp,
        color: baseTextColor,
      ),

      // نص الجسم
      bodyLarge: GoogleFonts.cairo(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5.sp,
        color: baseTextColor,
      ),
      bodyMedium: GoogleFonts.cairo(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25.sp,
        color: baseTextColor,
      ),
      bodySmall: GoogleFonts.cairo(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4.sp,
        color: secondaryTextColor,
      ),

      // تسميات
      labelLarge: GoogleFonts.cairo(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1.sp,
        color: baseTextColor,
      ),
      labelMedium: GoogleFonts.cairo(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5.sp,
        color: baseTextColor,
      ),
      labelSmall: GoogleFonts.cairo(
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5.sp,
        color: secondaryTextColor,
      ),
    );
  }

  static AppBarTheme _buildAppBarTheme() {
    return const AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
        size: 24,
      ),
    );
  }

  static AppBarTheme _buildDarkAppBarTheme() {
    return const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
        size: 24,
      ),
    );
  }

  static CardTheme _buildCardTheme() {
    return CardTheme(
      color: surface,
      elevation: 2,
      shadowColor: cardShadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      margin: EdgeInsets.all(8.w),
    );
  }

  static CardTheme _buildDarkCardTheme() {
    return CardTheme(
      color: const Color(0xFF1E1E1E),
      elevation: 2,
      shadowColor: const Color(0x80000000),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      margin: EdgeInsets.all(8.w),
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme({bool isDark = false}) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: cardShadow,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        textStyle: GoogleFonts.cairo(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme({bool isDark = false}) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        side: const BorderSide(color: primary, width: 2),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        textStyle: GoogleFonts.cairo(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static TextButtonThemeData _buildTextButtonTheme({bool isDark = false}) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        textStyle: GoogleFonts.cairo(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme({bool isDark = false}) {
    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF404040) : const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: error, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: error, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      hintStyle: GoogleFonts.cairo(
        fontSize: 16.sp,
        color: isDark ? const Color(0xFFB0B0B0) : textHint,
      ),
      labelStyle: GoogleFonts.cairo(
        fontSize: 16.sp,
        color: isDark ? const Color(0xFFB0B0B0) : textSecondary,
      ),
    );
  }

  static BottomNavigationBarThemeData _buildBottomNavigationBarTheme({bool isDark = false}) {
    return BottomNavigationBarThemeData(
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : surface,
      selectedItemColor: primary,
      unselectedItemColor: isDark ? const Color(0xFFB0B0B0) : textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: GoogleFonts.cairo(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.cairo(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  static SnackBarThemeData _buildSnackBarTheme({bool isDark = false}) {
    return SnackBarThemeData(
      backgroundColor: isDark ? const Color(0xFF2A2A2A) : surface,
      contentTextStyle: GoogleFonts.cairo(
        fontSize: 14.sp,
        color: isDark ? Colors.white : textPrimary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(16.w),
    );
  }

  static ProgressIndicatorThemeData _buildProgressIndicatorTheme({bool isDark = false}) {
    return const ProgressIndicatorThemeData(
      color: primary,
      linearTrackColor: Color(0x1A2196F3),
      circularTrackColor: Color(0x1A2196F3),
    );
  }

  static FloatingActionButtonThemeData _buildFABTheme({bool isDark = false}) {
    return const FloatingActionButtonThemeData(
      backgroundColor: secondary,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: CircleBorder(),
    );
  }

  static DrawerThemeData _buildDrawerTheme({bool isDark = false}) {
    return DrawerThemeData(
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : surface,
      scrimColor: overlay,
      elevation: 16,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
    );
  }

  static ListTileThemeData _buildListTileTheme({bool isDark = false}) {
    return ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      titleTextStyle: GoogleFonts.cairo(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white : textPrimary,
      ),
      subtitleTextStyle: GoogleFonts.cairo(
        fontSize: 14.sp,
        color: isDark ? const Color(0xFFB0B0B0) : textSecondary,
      ),
    );
  }

  static SwitchThemeData _buildSwitchTheme({bool isDark = false}) {
    return SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primary;
        }
        return isDark ? const Color(0xFFB0B0B0) : const Color(0xFF757575);
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primary.withOpacity(0.5);
        }
        return isDark ? const Color(0xFF404040) : const Color(0xFFE0E0E0);
      }),
    );
  }

  static CheckboxThemeData _buildCheckboxTheme({bool isDark = false}) {
    return CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primary;
        }
        return isDark ? const Color(0xFFB0B0B0) : const Color(0xFF757575);
      }),
      checkColor: MaterialStateProperty.all(Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }

  static RadioThemeData _buildRadioTheme({bool isDark = false}) {
    return RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primary;
        }
        return isDark ? const Color(0xFFB0B0B0) : const Color(0xFF757575);
      }),
    );
  }

  static IconThemeData _buildIconTheme({bool isDark = false}) {
    return IconThemeData(
      color: isDark ? Colors.white : textSecondary,
      size: 24.sp,
    );
  }

  static IconThemeData _buildPrimaryIconTheme({bool isDark = false}) {
    return const IconThemeData(
      color: primary,
      size: 24,
    );
  }
}

// ============================================
// مساعدات الثيم
// ============================================

class AppColors {
  // الألوان الأساسية
  static const Color primary = AppTheme.primary;
  static const Color secondary = AppTheme.secondary;
  static const Color success = AppTheme.success;
  static const Color warning = AppTheme.warning;
  static const Color error = AppTheme.error;
  static const Color info = AppTheme.info;

  // ألوان النص
  static const Color textPrimary = AppTheme.textPrimary;
  static const Color textSecondary = AppTheme.textSecondary;
  static const Color textHint = AppTheme.textHint;

  // ألوان الخلفية
  static const Color background = AppTheme.background;
  static const Color surface = AppTheme.surface;
  static const Color divider = AppTheme.divider;

  // ألوان مخصصة
  static const Color gold = AppTheme.gold;
  static const Color purple = AppTheme.purple;
  static const Color pink = AppTheme.pink;
  static const Color teal = AppTheme.teal;
  static const Color indigo = AppTheme.indigo;
}

class AppTextStyles {
  // أنماط النص
  static TextStyle get headlineLarge => AppTheme.lightTheme.textTheme.headlineLarge!;
  static TextStyle get headlineMedium => AppTheme.lightTheme.textTheme.headlineMedium!;
  static TextStyle get headlineSmall => AppTheme.lightTheme.textTheme.headlineSmall!;
  static TextStyle get titleLarge => AppTheme.lightTheme.textTheme.titleLarge!;
  static TextStyle get titleMedium => AppTheme.lightTheme.textTheme.titleMedium!;
  static TextStyle get titleSmall => AppTheme.lightTheme.textTheme.titleSmall!;
  static TextStyle get bodyLarge => AppTheme.lightTheme.textTheme.bodyLarge!;
  static TextStyle get bodyMedium => AppTheme.lightTheme.textTheme.bodyMedium!;
  static TextStyle get bodySmall => AppTheme.lightTheme.textTheme.bodySmall!;
  static TextStyle get labelLarge => AppTheme.lightTheme.textTheme.labelLarge!;
  static TextStyle get labelMedium => AppTheme.lightTheme.textTheme.labelMedium!;
  static TextStyle get labelSmall => AppTheme.lightTheme.textTheme.labelSmall!;
}

class AppSpacing {
  // المسافات
  static double get xs => 4.0.w;
  static double get sm => 8.0.w;
  static double get md => 16.0.w;
  static double get lg => 24.0.w;
  static double get xl => 32.0.w;
  static double get xxl => 48.0.w;
}

class AppBorderRadius {
  // نصف أقطار الحدود
  static double get xs => 4.0.r;
  static double get sm => 8.0.r;
  static double get md => 12.0.r;
  static double get lg => 16.0.r;
  static double get xl => 20.0.r;
  static double get xxl => 24.0.r;
  static double get circle => 999.0.r;
}

class AppElevation {
  // ارتفاعات الظلال
  static double get none => 0.0;
  static double get xs => 2.0;
  static double get sm => 4.0;
  static double get md => 8.0;
  static double get lg => 16.0;
  static double get xl => 24.0;
}