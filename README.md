# TodayTodo

## APK 업데이트 배포

`www/index.html`의 `UPDATE_MANIFEST_URL`을 HTTPS로 배포한 `latest.json` 주소로 변경합니다.
`latest.json`은 다음 형식이며, `apkUrl`은 같은 방식으로 접근 가능한 최신 APK 주소여야 합니다.

```json
{
	"version": "1.0",
	"apkUrl": "https://example.com/releases/today-todo-1.0.apk",
	"notes": "업데이트 내용"
}
```

새 APK를 서버에 올리고 `latest.json`의 버전을 높이면 앱 설정의 `업데이트 확인`에서 다운로드 및 Android 설치 화면을 실행합니다. Android에서는 출처를 알 수 없는 앱 설치 허용이 필요할 수 있습니다.

빌드된 APK를 `updates` 폴더에 복사하고 manifest를 갱신하려면 다음처럼 실행합니다.

```powershell
npm run publish:update -- -Version 1.0 -ApkUrl https://example.com/releases/today-todo-1.0.apk -Notes "업데이트 내용"
```

이 명령은 `updates/today-todo-1.0.apk`와 `updates/latest.json`을 생성합니다. `updates` 폴더 전체를 HTTPS 정적 호스팅에 업로드하고, `www/index.html`의 `UPDATE_MANIFEST_URL`을 그 `latest.json` 주소로 설정합니다.

## 오프라인 및 모바일 사용

`www/service-worker.js`가 앱 셸과 기본 이미지·소리·Three.js 파일을 캐시하므로 첫 온라인 실행 후 일정, 메모, 펫 데이터와 기본 기능을 오프라인에서도 사용할 수 있습니다. 영어사전 온라인 검색과 날씨 자동 조회처럼 외부 API가 필요한 기능은 연결이 있을 때만 동작하며, 내장 사전 단어는 오프라인에서도 검색할 수 있습니다.

모바일에서는 세로 스크롤과 안전 영역 여백을 사용하고, 모달 내용이 짧은 화면에서 잘리지 않도록 동작합니다. 웹에서 설치 가능한 형태로 제공할 때는 `manifest.webmanifest`와 `service-worker.js`를 `www`와 함께 HTTPS로 배포해야 합니다.