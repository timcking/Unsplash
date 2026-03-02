# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get          # Install dependencies
flutter run              # Run app in debug mode
flutter test             # Run tests
flutter analyze          # Lint/static analysis
flutter build apk        # Build Android APK
flutter build ios        # Build iOS
flutter clean            # Clean build artifacts
```

Run a single test file:
```bash
flutter test test/widget_test.dart
```

## API Credentials Setup

`lib/config.dart` is gitignored and must be created before running the app. Copy from the example:

```bash
cp lib/config.dart.example lib/config.dart
```

Then replace the placeholder values with real Unsplash API credentials from [unsplash.com/developers](https://unsplash.com/developers).

## Architecture

This is a single-screen Flutter app with no external state management — only `setState()`.

**Key files:**
- `lib/main.dart` — entire app logic in one file; `MyApp` (root widget) + `MyHomePage` (stateful main screen)
- `lib/constants.dart` — UI theme constants (`kAppColor`, `kAppBarColor`, `kButtonStyle`)
- `lib/config.dart` — API credentials (gitignored); `kUnsplashAccessKey`, `kUnsplashSecretKey`

**Data flow:** `loadAppCredentials()` (in `initState`) → creates `UnsplashClient` per request → `getSearchImage()` or `getRandomImage()` fetches URLs → stored in `listImages` List → rendered via `ListView.builder` with `Image.network`.

**Image download:** Tapping an image in the list downloads it via `http.get`, saves to `getApplicationDocumentsDirectory()` using `path_provider`, then shows the saved file in an `AlertDialog`.

**Theme:** Material 3, Deep Orange accent color scheme, beige scaffold background (`#ECDEC2`).
