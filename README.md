# boro-android

## Local runtime config

This project no longer needs to keep app config values in source.

1. Copy `dart_defines.example.json` to `dart_defines.local.json`.
2. Fill in your own backend URL, Kakao keys, and Firebase Android config.
3. Run Flutter with:

```bash
flutter run --dart-define-from-file=dart_defines.local.json
```

You can also pass values directly:

```bash
flutter run \
  --dart-define=BACKEND_BASE_URL=https://boro-backend-production.up.railway.app \
  --dart-define=KAKAO_NATIVE_APP_KEY=your_native_app_key \
  --dart-define=KAKAO_JAVASCRIPT_APP_KEY=your_javascript_app_key \
  --dart-define=FIREBASE_ANDROID_GOOGLE_SERVICES_JSON_B64=your_base64_google_services_json
```

`KAKAO_NATIVE_APP_KEY` is used by Flutter and Android Manifest redirect handling.
`KAKAO_JAVASCRIPT_APP_KEY` is used by `kakao_map_plugin`.
`BACKEND_BASE_URL` overrides the API server base URL.
`FIREBASE_ANDROID_GOOGLE_SERVICES_JSON_B64` is decoded by Gradle to generate `android/app/google-services.json` at build time.

On PowerShell, you can base64-encode a downloaded `google-services.json` file with:

```powershell
[Convert]::ToBase64String(
  [Text.Encoding]::UTF8.GetBytes((Get-Content path\to\google-services.json -Raw))
)
```
