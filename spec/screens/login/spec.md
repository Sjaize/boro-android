# Login Screen Spec

## 1) 개요
- screen_id: login
- 목적: 사용자 인증(로그인) 진입/완료

## 2) 사용자 시나리오
- 진입: (예: splash -> login)
- 성공: 로그인 성공 후 이동 경로
- 실패: 에러 메시지/재시도

## 3) 레이아웃(구성요소)
- 상단: (예: 로고/타이틀)
- 입력: (예: 이메일/비밀번호 또는 휴대폰/인증번호)
- 액션: 로그인 버튼, 회원가입 이동, 비밀번호 찾기, 소셜 로그인 등
- 하단: 약관/개인정보 처리방침 링크(필요 시)

## 4) 상태(State)
- default
- loading (로그인 요청 중)
- error (로그인 실패)
- disabled (입력값 유효성 미충족)

## 5) 입력/유효성
- 필드 목록:
  - (예: email) 형식 검증
  - (예: password) 최소 길이/문자 규칙
- 에러 문구:
  - (예: "이메일 형식이 올바르지 않습니다.")
  - (예: "비밀번호를 입력해주세요.")

## 6) API/데이터 계약(알고 있는 만큼)
- request:
  - (예: email, password)
- response:
  - (예: accessToken, refreshToken, user)
- 실패 케이스:
  - (예: 401 invalid credentials)
  - (예: 네트워크 오류)

## 7) 네비게이션
- 로그인 성공 후: (예: `/home`)
- 회원가입: (예: `/signup`)
- 비밀번호 찾기: (예: `/reset-password`)

## 8) 스타일 가이드
- 타이포: `spec/app.md`의 Typography 기준 사용
- 여백/정렬: (나중에 채움)
- 색상: (나중에 채움)

## 9) 화면 근거(이미지 참조)
- PNG 경로: `spec/screens/login/images/`
- 이미지 파일명: (예: `01.png`, `02.png`...)
- 영역 주석(있으면):

