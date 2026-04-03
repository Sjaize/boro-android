import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

import 'theme/app_typography.dart';
import 'theme/app_colors.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/post/post_detail_screen.dart';
import 'screens/post/post_create_screen.dart';
import 'screens/trade/trade_screen.dart';
import 'screens/search/search_screen.dart';
import 'package:boro_android/data/mock_data.dart';
import 'screens/mypage/mypage_screen.dart';
import 'screens/mypage/notification_settings_screen.dart';
import 'screens/mypage/chat_notification_settings_screen.dart';
import 'screens/mypage/trade_notification_settings_screen.dart';
import 'screens/mypage/location_notification_settings_screen.dart';
import 'screens/mypage/notification_range_settings_screen.dart';
import 'screens/mypage/keyword_notification_settings_screen.dart';
import 'screens/mypage/keyword_registration_screen.dart';
import 'screens/mypage/trade/trade_history_screen.dart';
import 'screens/mypage/post/my_posts_screen.dart';
import 'screens/mypage/post/favorites_screen.dart';
import 'screens/chat/chat_list_screen.dart';
import 'screens/chat/chat_room_screen.dart';
import 'screens/chat/review_write_screen.dart';
import 'screens/chat/review_complete_screen.dart';
import 'widgets/app_scroll_behavior.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  /// 카카오 맵 플러그인 초기화
  /// JavaScript App Key만 사용합니다.
  AuthRepository.initialize(
    appKey: '7e551c6da777e7484f7e0f9c61fbe19d',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BORO',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const AppScrollBehavior(),
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
        '/mypage': (context) => const MyPageScreen(),
        '/notification-settings': (context) =>
            const NotificationSettingsScreen(),
        '/chat-notification-settings': (context) =>
            const ChatNotificationSettingsScreen(),
        '/trade-notification-settings': (context) =>
            const TradeNotificationSettingsScreen(),
        '/location-notification-settings': (context) =>
            const LocationNotificationSettingsScreen(),
        '/notification-range-settings': (context) =>
            const NotificationRangeSettingsScreen(),
        '/keyword-notification-settings': (context) =>
            const KeywordNotificationSettingsScreen(),
        '/keyword-registration': (context) =>
            const KeywordRegistrationScreen(),
        '/trade-history': (context) => const TradeHistoryScreen(),
        '/my-posts': (context) => const MyPostsScreen(),
        '/favorites': (context) => const FavoritesScreen(),
        '/chat-list': (context) => const ChatListScreen(),
        '/chat-room': (context) => const ChatRoomScreen(),
        '/review-write': (context) => const ReviewWriteScreen(),
        '/review-complete': (context) => const ReviewCompleteScreen(),
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
