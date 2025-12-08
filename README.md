# Rebook

도서에 대힌 리뷰를 남길 수 있는 안드로이드 애플리케이션입니다.

## 주요 기능

- 회원가입 / 로그인
- 도서 검색
- 도서 상세 정보 조회
- 도서리뷰 확인
- 도서 리뷰 작성
- 내가 읽은 책 마크

## 기술 스택

- Dart 3.9.2
- Flutter 3.35.3
- Supabase
- Kakao API

## 설치 및 실행 방법

```bash
git clone https://github.com/youngungyun/flutter
cd flutter
flutter pub get
flutter run
```

## 환경 변수

실행 전 환경 변수 설정
`.env` 파일 생성 후 아래 내용 작성

```
PROJECT_URL=<your_project_url> // Supabase 프로젝트 URL
PROJECT_API_KEY=<your_project_api_key> // Supabase 프로젝트 API 키
KAKAO_API_KEY=<your_kakao_api_key> // 카카오 API 키
```

## 디렉터리 구조

```
lib
 ┣ dto                     # DTO 클래스
 ┃ ┣ auth
 ┃ ┣ book
 ┃ ┗ review
 ┣ screens                 # 화면 UI
 ┃ ┣ auth
 ┃ ┣ book
 ┃ ┣ review
 ┃ ┗ main_screen.dart      # 초기 화면 UI
 ┣ services                # 로직 수행
 ┣ widgets                 # 재사용 위젯
 ┃ ┣ auth
 ┃ ┣ book
 ┃ ┣ common
 ┃ ┗ review
 ┣ router
 ┃ ┗ app_router.dart       # 라우터 클래스
 ┣ themes
 ┃ ┗ app_theme.dart        # ColorScheme 클래스
 ┣ utils                   # 유틸리티 클래스
 ┣ exceptions              # 커스텀 예외
 ┣ mocks                   # 테스트용 Mock 데이터
 ┗ main.dart               # 메인 실행 클래스
```
