# Rebook

도서에 대힌 리뷰를 남길 수 있는 모바일 애플리케이션입니다.

## 주요 기능
- 회원가입 / 로그인
- 도서 검색
- 도서 상세 정보 조회
- 도서리뷰 확인
- 도서 리뷰 작성
- 내가 읽은 책 마크

## 기술 스택
- Flutter(프론트 엔드 및 비즈니스 로직)
- Supabase(데이터베이스)
- Kakao API(도서 검색)

## 설치 방법
```bash
git clone https://github.com/youngungyun/flutter
cd flutter
flutter pub get
flutter run
```

## 환경 변수
`.env` 파일 생성 후 아래 내용 작성
```
PROJECT_URL=<your_project_url> // Supabase 프로젝트 URL
PROJECT_API_KEY=<your_project_api_key> // Supabase 프로젝트 API 키
KAKAO_API_KEY=<your_kakao_api_key> // 카카오 API 키
```

