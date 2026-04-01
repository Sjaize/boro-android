# BORO 앱 개발 가이드라인

## 프로젝트 개요
- 앱 이름: BORO (근거리 즉시 대여 서비스)
- 플랫폼: Flutter (Android 우선)
- 대회: 세모톤 2026 (발표 6분 + 실시간 시연)
- 목표: 시연 가능한 앱 완성

## 기술 스택
- Flutter (UI)
- 카카오 소셜 로그인
- FCM (푸시 알림)
- 카카오맵 API
- AI 대여료 추천 API (백엔드 팀 담당)

## 디자인 시스템

### 폰트
- Family: `Pretendard`
- H1: Bold(700) / 24px
- H2: SemiBold(600) / 20px
- H3: Bold(700) / 18px
- B1: Bold(700) / 16px
- B2: SemiBold(600) / 16px
- B3: Medium(500) / 16px
- B4: Medium(500) / 14px
- C1: SemiBold(600) / 12px
- C2: Medium(500) / 12px

### 색상
- Primary: `#1570EF`
- Primary Light: `#EFF8FF`
- Text Dark: `#0A0D12`
- Text Medium: `#535862`
- Text Light: `#717680`
- Text Hint: `#A4A7AE`
- Border: `#D5D7DA`
- Divider: `#E9EAEB`
- BG Card: `#F5F5F5`
- BG Page: `#FAFAFA`
- White: `#FFFFFF`

## Figma 정보
- 파일 키: `wlpt8IDYNrN5TuMLkIG98Y`
- 화면 섹션 node-id: `6:778` (hi-fi)
- 컴포넌트 섹션 node-id: `1:712`

### 주요 화면 node-id
| 화면 | node-id |
|------|---------|
| 스플래시 | `6:4356` |
| 로그인 | `6:779` |
| 튜토리얼1 | `6:786` |
| 홈 피드 | `6:1478` |
| 게시글 상세 | `6:1080` |
| 게시글 작성 | `6:3602` |
| 검색(1) | `6:1236` |
| 채팅 목록 | `6:964` |
| 채팅방(1) | `6:3362` |
| 거래/빌려주세요(1) | `6:1596` |
| 거래/빌려드려요 | `6:2867` |
| 마이페이지 | `6:880` |
| 후기 | `6:1018` |

## 프로젝트 구조 규칙
- 화면 파일: `lib/screens/{화면명}/{화면명}_screen.dart`
- 공용 위젯: `lib/widgets/`
- 테마/스타일: `lib/theme/`
- 상수: `lib/constants/`
- 목업 데이터: `lib/data/mock_data.dart`

## 코딩 규칙
- 실제 백엔드 없음 → 목업 데이터로 UI 구현
- Figma 기준 화면 사이즈: 384×824px (LayoutBuilder로 스케일 적용)
- 네비게이션: Named routes 사용
- 폰트 스케일: `scaleY = constraints.maxHeight / 824`
- 간격 스케일: `scaleX = constraints.maxWidth / 384`

## 시연 핵심 플로우
1. 기기A: 글 등록 (노트북 충전기 C타입, 2,000원)
2. 기기B: FCM 알림 수신 → 앱 열기 → 채팅 → 결제 (1분 내)
