# boro-android

## Local Kakao keys

This project no longer keeps Kakao keys in source.

1. Copy [`dart_defines.example.json`](/Users/bag-in-yeong/Desktop/boro-android/dart_defines.example.json) to `dart_defines.local.json`.
2. Fill in your own Kakao keys.
3. Run Flutter with:

```bash
flutter run --dart-define-from-file=dart_defines.local.json
```

You can also pass values directly:

```bash
flutter run \
  --dart-define=KAKAO_NATIVE_APP_KEY=your_native_app_key \
  --dart-define=KAKAO_JAVASCRIPT_APP_KEY=your_javascript_app_key
```

`KAKAO_NATIVE_APP_KEY` is used by Flutter and Android Manifest redirect handling.
`KAKAO_JAVASCRIPT_APP_KEY` is used by `kakao_map_plugin`.
