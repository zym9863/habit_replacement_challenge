import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/habit_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HabitProvider(),
      child: MaterialApp(
        title: '不如换掉它',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF3F51B5), // 靛蓝色作为主色调
            primary: const Color(0xFF3F51B5),
            secondary: const Color(0xFF4CAF50), // 绿色作为次要色调
            tertiary: const Color(0xFFFF9800), // 橙色作为第三色调
            error: const Color(0xFFE53935), // 错误色
            background: const Color(0xFFF5F5F5), // 背景色
            surface: Colors.white,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          // 应用栏主题
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0, // 扁平化设计
            backgroundColor: Color(0xFF3F51B5),
            foregroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          // 按钮主题
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF3F51B5),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
          // 卡片主题
          cardTheme: CardTheme(
            color: Colors.white,
            elevation: 3,
            shadowColor: Colors.black.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          ),
          // 文本主题
          textTheme: const TextTheme(
            headlineMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            titleMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            bodyLarge: TextStyle(fontSize: 16),
            bodyMedium: TextStyle(fontSize: 14),
          ),
          // 图标主题
          iconTheme: const IconThemeData(
            color: Color(0xFF3F51B5),
            size: 24,
          ),
          // 进度指示器主题
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: Color(0xFF4CAF50),
            linearTrackColor: Color(0xFFE0E0E0),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
