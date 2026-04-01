# BORO 파일 구조

```
boro-android/
├── lib/
│   ├── main.dart                          # 앱 진입점, 라우팅
│   ├── theme/
│   │   ├── app_typography.dart            # ✅ 폰트 스타일
│   │   └── app_colors.dart                # 📋 색상 상수
│   ├── constants/
│   │   └── app_routes.dart                # 📋 라우트 이름 상수
│   ├── data/
│   │   └── mock_data.dart                 # 📋 목업 데이터
│   ├── widgets/
│   │   ├── bottom_nav_bar.dart            # 📋 하단 내비게이션
│   │   ├── post_card.dart                 # 📋 게시글 카드
│   │   └── common_app_bar.dart            # 📋 공용 앱바
│   └── screens/
│       ├── splash/
│       │   └── splash_screen.dart         # ✅ 스플래시
│       ├── login/
│       │   └── login_screen.dart          # ✅ 로그인
│       ├── onboarding/
│       │   └── onboarding_screen.dart     # 📋 온보딩
│       ├── home/
│       │   └── home_screen.dart           # 📋 홈 피드
│       ├── post/
│       │   ├── post_detail_screen.dart    # 📋 게시글 상세
│       │   └── post_create_screen.dart    # 📋 게시글 작성
│       ├── search/
│       │   └── search_screen.dart         # 📋 검색
│       ├── map/
│       │   └── map_screen.dart            # 📋 지도 보기
│       ├── chat/
│       │   ├── chat_list_screen.dart      # 📋 채팅 목록
│       │   └── chat_room_screen.dart      # 📋 채팅방
│       ├── payment/
│       │   └── payment_screen.dart        # 📋 결제 (UI만)
│       ├── trade/
│       │   ├── trade_lend_screen.dart     # 📋 거래현황/빌려드려요
│       │   └── trade_borrow_screen.dart   # 📋 거래현황/빌려주세요
│       ├── review/
│       │   └── review_screen.dart         # 📋 후기/평가
│       └── mypage/
│           └── mypage_screen.dart         # 📋 마이페이지
├── assets/
│   ├── fonts/
│   │   ├── Pretendard-Bold.otf
│   │   ├── Pretendard-SemiBold.ttf
│   │   ├── Pretendard-Medium.ttf
│   │   └── Pretendard-ExtraBold.otf
│   └── images/
│       └── splash/
│           └── Boro.png
├── CLAUDE.md
├── PROGRESS.md
├── STRUCTURE.md
└── pubspec.yaml
```

## 범례
- ✅ 완료
- 🔄 진행중
- 📋 예정
