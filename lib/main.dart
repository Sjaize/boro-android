import 'package:flutter/material.dart';

import 'theme/app_typography.dart';
import 'theme/app_colors.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/post/post_detail_screen.dart';
import 'screens/post/post_create_screen.dart';
import 'screens/trade/trade_screen.dart';
import 'screens/search/search_screen.dart';
import 'data/mock_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BORO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        textTheme: AppTypography.textTheme,
        fontFamily: AppTypography.fontFamily,
      ),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/post-create': (context) => const PostCreateScreen(),
        '/trade': (context) => const TradeScreen(),
        '/search': (context) => const SearchScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/post-detail') {
          final post = settings.arguments as PostItem;
          return MaterialPageRoute(
            builder: (context) => PostDetailScreen(post: post),
          );
        }
        return null;
      },
    );
  }
}
