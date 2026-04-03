import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

import 'data/mock_data.dart';
import 'screens/chat/chat_list_screen.dart';
import 'screens/chat/chat_room_screen.dart';
import 'screens/chat/review_complete_screen.dart';
import 'screens/chat/review_write_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/home/profile_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/mypage/chat_notification_settings_screen.dart';
import 'screens/mypage/keyword_notification_settings_screen.dart';
import 'screens/mypage/keyword_registration_screen.dart';
import 'screens/mypage/location_notification_settings_screen.dart';
import 'screens/mypage/mypage_screen.dart';
import 'screens/mypage/notification_range_settings_screen.dart';
import 'screens/mypage/notification_settings_screen.dart';
import 'screens/mypage/post/favorites_screen.dart';
import 'screens/mypage/post/my_posts_screen.dart';
import 'screens/mypage/trade/trade_history_screen.dart';
import 'screens/mypage/trade_notification_settings_screen.dart';
import 'screens/notification/notification_lock_screen.dart';
import 'screens/notification/notification_screen.dart';
import 'screens/post/category_screen.dart';
import 'screens/post/post_create_screen.dart';
import 'screens/post/post_detail_screen.dart';
import 'screens/search/search_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/trade/location_screen.dart';
import 'screens/trade/space_partner_screen.dart';
import 'screens/trade/trade_screen.dart';
import 'screens/tutorial/tutorial_screen_1.dart';
import 'screens/tutorial/tutorial_screen_2.dart';
import 'screens/tutorial/tutorial_screen_3.dart';
import 'screens/tutorial/tutorial_screen_4.dart';
import 'screens/tutorial/tutorial_screen_5.dart';
import 'services/auth_service.dart';
import 'theme/app_colors.dart';
import 'theme/app_typography.dart';
import 'widgets/app_scroll_behavior.dart';

const String _kakaoNativeAppKey = '45bc63567b883e56bd21c32fa44c8e2a';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AuthRepository.initialize(
    appKey: '7e551c6da777e7484f7e0f9c61fbe19d',
  );
  KakaoSdk.init(nativeAppKey: _kakaoNativeAppKey);
  await AuthService.loadTokens();
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
        '/tutorial-1': (context) => const TutorialScreen1(),
        '/tutorial-2': (context) => const TutorialScreen2(),
        '/tutorial-3': (context) => const TutorialScreen3(),
        '/tutorial-4': (context) => const TutorialScreen4(),
        '/tutorial-5': (context) => const TutorialScreen5(),
        '/home': (context) => const HomeScreen(),
        '/post-create': (context) => const PostCreateScreen(),
        '/category': (context) => const CategoryScreen(),
        '/trade': (context) => const TradeScreen(),
        '/space-partner': (context) => const SpacePartnerScreen(),
        '/search': (context) => const SearchScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/notification': (context) => const NotificationScreen(),
        '/notification-lock': (context) => const NotificationLockScreen(),
        '/location-search': (context) => const LocationSearchScreen(),
        '/location-map': (context) => const LocationMapScreen(),
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
          if (settings.arguments is Map<String, dynamic>) {
            final args = settings.arguments as Map<String, dynamic>;
            final post = args['post'] as PostItem;
            final isOfficialPartner =
                args['isOfficialPartner'] as bool? ?? false;
            return MaterialPageRoute(
              builder: (context) => PostDetailScreen(
                post: post,
                isOfficialPartner: isOfficialPartner,
              ),
            );
          }
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
