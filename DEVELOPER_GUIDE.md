# 🛠️ دليل المطور - نظام إدارة السوبر ماركت

## 📋 جدول المحتويات

1. [إعداد البيئة](#إعداد-البيئة)
2. [هيكل المشروع](#هيكل-المشروع)
3. [إضافة ميزات جديدة](#إضافة-ميزات-جديدة)
4. [التطوير والتصميم](#التطوير-و-التصميم)
5. [إدارة البيانات](#إدارة-البيانات)
6. [الاختبار](#الاختبار)
7. [النشر والتوزيع](#النشر-و-التوزيع)

---

## 🔧 إعداد البيئة

### المتطلبات الأساسية
```bash
# تثبيت Flutter
flutter --version  # يجب أن يكون >= 3.0.0

# تثبيت Dart
dart --version     # يجب أن يكون >= 3.0.0

# تثبيت Android Studio أو VS Code
# تثبيت Android SDK
# إعداد محاكي Android
```

### إعداد المشروع
```bash
# 1. استنساخ المشروع
git clone [repository-url]
cd supermarket_complete

# 2. تثبيت المكتبات
flutter pub get

# 3. تحليل الكود
flutter analyze

# 4. تشغيل الاختبارات
flutter test

# 5. تشغيل المشروع
flutter run
```

### إعدادات IDE

#### VS Code
- تثبيت Flutter Extension
- تثبيت Dart Extension
- إعداد Flutter SDK Path
- تفعيل Code Actions

#### Android Studio
- تثبيت Flutter Plugin
- إعداد Flutter SDK
- تفعيل Code Inspection

---

## 📁 هيكل المشروع

### هيكل المجلدات
```
lib/
├── constants/          # الثوابت والإعدادات
│   └── theme.dart     # نظام الألوان والتصميم
├── models/            # نماذج البيانات
│   └── models.dart    # جميع النماذج
├── screens/           # شاشات التطبيق
│   ├── login_screen.dart
│   ├── dashboard_screen.dart
│   └── ...
├── widgets/           # مكونات مخصصة
│   └── custom_widgets.dart
├── services/          # خدمات API وقواعد البيانات
├── providers/         # إدارة الحالة
├── utils/             # أدوات مساعدة
└── main.dart         # نقطة الدخول الرئيسية
```

### نمط البنية المعمارية

#### Model-View-Provider (MVP)
- **Models**: البيانات والهيكل
- **Views**: واجهة المستخدم (Screens & Widgets)
- **Providers**: إدارة الحالة والمنطق

#### قواعد التسمية
- **الملفات**: snake_case.dart
- **الكلاسات**: PascalCase
- **الدوال والمتغيرات**: camelCase
- **الثوابت**: UPPER_CASE

---

## ➕ إضافة ميزات جديدة

### 1. إضافة نموذج جديد

```dart
// في lib/models/models.dart
class NewModel {
  final String id;
  final String name;
  // ... باقي الخصائص
  
  NewModel({
    required this.id,
    required this.name,
  });
  
  // تحويل من/إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
  
  factory NewModel.fromJson(Map<String, dynamic> json) {
    return NewModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
```

### 2. إضافة شاشة جديدة

```dart
// في lib/screens/new_screen.dart
import 'package:flutter/material.dart';
import '../constants/theme.dart';
import '../widgets/custom_widgets.dart';

class NewScreen extends StatelessWidget {
  const NewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('شاشة جديدة'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('المحتوى الجديد'),
      ),
    );
  }
}
```

### 3. إضافة مكون مخصص

```dart
// في lib/widgets/custom_component.dart
class CustomComponent extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  
  const CustomComponent({
    super.key,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          title,
          style: AppTextStyles.titleMedium,
        ),
      ),
    );
  }
}
```

### 4. تحديث التنقل

```dart
// في lib/main.dart
GoRoute(
  path: '/new-feature',
  name: 'newFeature',
  builder: (context, state) => const NewScreen(),
),
```

---

## 🎨 التطوير والتصميم

### استخدام نظام الألوان

```dart
// الألوان الأساسية
AppColors.primary      // اللون الأساسي
AppColors.secondary    // اللون الثانوي
AppColors.success      // أخضر للنجاح
AppColors.warning      // برتقالي للتحذير
AppColors.error        // أحمر للخطأ

// ألوان النص
AppColors.textPrimary      // نص أساسي
AppColors.textSecondary    // نص ثانوي
AppColors.textHint        // نص تلميح

// ألوان الخلفية
AppColors.background     // خلفية الصفحة
AppColors.surface        // سطح البطاقات
AppColors.divider        // فواصل
```

### استخدام أنماط النص

```dart
// أنماط النص المتاحة
AppTextStyles.headlineLarge   // عنوان كبير
AppTextStyles.headlineMedium  // عنوان متوسط
AppTextStyles.headlineSmall   // عنوان صغير
AppTextStyles.titleLarge      // عنوان كبير
AppTextStyles.titleMedium     // عنوان متوسط
AppTextStyles.titleSmall      // عنوان صغير
AppTextStyles.bodyLarge       // نص كبير
AppTextStyles.bodyMedium      // نص متوسط
AppTextStyles.bodySmall       // نص صغير
AppTextStyles.labelLarge      // تسمية كبيرة
AppTextStyles.labelMedium     // تسمية متوسطة
AppTextStyles.labelSmall      // تسمية صغيرة
```

### استخدام المسافات

```dart
AppSpacing.xs    // 4.0.w
AppSpacing.sm    // 8.0.w
AppSpacing.md    // 16.0.w
AppSpacing.lg    // 24.0.w
AppSpacing.xl    // 32.0.w
AppSpacing.xxl   // 48.0.w
```

### استخدام نصف أقطار الحدود

```dart
AppBorderRadius.xs     // 4.0.r
AppBorderRadius.sm     // 8.0.r
AppBorderRadius.md     // 12.0.r
AppBorderRadius.lg     // 16.0.r
AppBorderRadius.xl     // 20.0.r
AppBorderRadius.xxl    // 24.0.r
AppBorderRadius.circle // 999.0.r
```

### استخدام المكونات المخصصة

```dart
// زر مخصص
CustomButton(
  text: 'تسجيل الدخول',
  onPressed: () {},
  isLoading: false,
)

// حقل نص مخصص
CustomTextField(
  label: 'البريد الإلكتروني',
  hint: 'أدخل بريدك الإلكتروني',
  controller: _controller,
)

// بطاقة مخصصة
CustomCard(
  child: Text('المحتوى'),
  onTap: () {},
)

// عنصر قائمة مخصص
CustomListTile(
  icon: Icons.home,
  title: 'الرئيسية',
  onTap: () {},
)
```

---

## 💾 إدارة البيانات

### نمط البيانات المحلي

```dart
// استخدام SharedPreferences
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _userKey = 'user_data';
  
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(userData));
  }
  
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userKey);
    if (userDataString != null) {
      return json.decode(userDataString);
    }
    return null;
  }
}
```

### نماذج البيانات

```dart
// إنشاء نموذج جديد
class Product {
  final String id;
  final String name;
  final double price;
  
  Product({
    required this.id,
    required this.name,
    required this.price,
  });
  
  // تحويل من/إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
  
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
    );
  }
}
```

---

## 🧪 الاختبار

### اختبار الوحدة

```dart
// في test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supermarket_complete/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
```

### اختبار النموذج

```dart
// في test/models/product_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:supermarket_complete/models/models.dart';

void main() {
  group('Product Model', () {
    test('should create product from JSON', () {
      final json = {
        'id': '1',
        'name': 'Test Product',
        'price': 10.0,
      };
      
      final product = Product.fromJson(json);
      
      expect(product.id, '1');
      expect(product.name, 'Test Product');
      expect(product.price, 10.0);
    });
    
    test('should convert product to JSON', () {
      final product = Product(
        id: '1',
        name: 'Test Product',
        price: 10.0,
      );
      
      final json = product.toJson();
      
      expect(json['id'], '1');
      expect(json['name'], 'Test Product');
      expect(json['price'], 10.0);
    });
  });
}
```

---

## 🚀 النشر والتوزيع

### بناء التطبيق

```bash
# بناء للأندرويد
flutter build apk --release
flutter build appbundle --release

# بناء لـ iOS
flutter build ios --release

# بناء للويب
flutter build web --release
```

### إعدادات النشر

#### Android (android/app/build.gradle)
```gradle
android {
    compileSdkVersion 33
    minSdkVersion 21
    targetSdkVersion 33
    
    buildTypes {
        release {
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

#### iOS (ios/Runner/Info.plist)
```xml
<key>CFBundleDisplayName</key>
<string>نظام إدارة السوبر ماركت</string>
<key>CFBundleIdentifier</key>
<string>com.supermarket.app</string>
<key>CFBundleVersion</key>
<string>1.0.0</string>
```

---

## 🔍 أفضل الممارسات

### أداء التطبيق
- استخدم `const` constructors عندما أمكن
- تجنب إعادة بناء الwidgets غير الضرورية
- استخدم `Lazy Loading` للبيانات الكبيرة
- قم بتحسين الصور والأصول

### أمان التطبيق
- لا تحفظ كلمات مرور في النصوص
- استخدم تشفير البيانات الحساسة
- تحقق من صحة المدخلات
- استخدم HTTPS للطلبات

### تجربة المستخدم
- اجعل الواجهة سهلة الاستخدام
- استخدم رموز واضحة ومعبرة
- اضمن استجابة سريعة للتفاعلات
- اختبر على أجهزة مختلفة

---

## 📞 الدعم والمساعدة

### الموارد المفيدة
- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Documentation](https://dart.dev/guides)
- [Flutter Community](https://flutter.dev/community)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)

### فريق التطوير
- **المطور الرئيسي**: [اسم المطور]
- **البريد الإلكتروني**: dev@supermarket.com
- **التليجرام**: @supermarket_dev

---

## 📝 سجل التغييرات

### الإصدار 1.0.0 (2025-12-12)
- ✅ إضافة نظام تسجيل الدخول
- ✅ إنشاء لوحة التحكم الرئيسية
- ✅ إضافة نظام الألوان والتصميم
- ✅ إنشاء المكونات المخصصة
- ✅ إعداد نظام التنقل
- ✅ إضافة التوثيق الشامل

---

<div align="center">

**🛠️ Happy Coding! 💻**

</div>