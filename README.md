# Flutter Wordpress Podcast

Podcast white label app based on Wordpress API using Flutter framework.

[![ko-fi](https://www.ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/P5P813IQT)

## Preview

![screenshot1](https://github.com/PierreBresson/flutter-wordpress-podcast/blob/main/preview/thinkerview-1.jpg)

## Apps

Thinkerview - [Android](https://play.google.com/store/apps/details?id=com.thinkerview&hl=fr) - [iOS](https://apps.apple.com/us/app/thinkerview/id1406076265?ls=1)

Cause Commune - [Android](https://play.google.com/store/apps/details?id=com.cause.commune) - [iOS](https://apps.apple.com/us/app/cause-commune/id1458650964?ls=1)

## Roadmap

Already existing and planned features.

- [x] Dark mode support
- [x] Test widgets and cubits
- [x] Recommended books for Thinkerview - markdown screen
- [x] Play audio in the background and respond to controls on the lockscreen, media notification, headset
- [x] Audio playback when leaving app
- [x] Search
- [x] Env config / scripts - white label apps
- [ ] Stream live radio
- [ ] Refactor into smaller widgets
- [ ] Tests
- [ ] Log crash/bugs to Firebase Crashlytics WIP: missing iOS on cause commune
- [ ] Improved design
- [ ] Image caching
- [ ] localization - i18
- [ ] Categories screen
- [ ] Details when clicking on a podcast item
- [ ] Chromecast / Airplay
- [ ] Download podcast / offline mode
- [ ] share episode with friend / deep-linking to open a specific episode
- [ ] AndroidAuto / CarPlay

App tested and working on :

- [x] iOS
- [x] Android
- [ ] Web
- [ ] MacOS - in progress
- [ ] Linux

### Getting started

Create `.env` file with `APP=causecommune` or `APP=thinkerview` inside.
Create `firebase_options.dart` thanks to [firebase cli](https://codewithandrea.com/articles/firebase-flutterfire-cli-flavors/) `flutterfire config` and put it in `/lib/firebase/`.

### Run the app

`flutter pub get`

Android :

`flutter clean && flutter run --flavor thinkerview`

`flutter clean && flutter run --flavor causecommune`

iOS :

`flutter run --flavor "Cause Commune"`

`flutter run --flavor Thinkerview`

MacOS (experimental) :

`flutter run -d macos`

### Build app

Android:

`flutter build appbundle --flavor thinkerview`

`flutter build appbundle --flavor causecommune`

iOS:
Select project and archive on Xcode

MacOS (experimental) :
`flutter build macos`

### Upload dSYMs

Put dSYMs.zip in Flutter Wordpress Podcast app folder and then in the terminal, run the following :

```
ios/Pods/FirebaseCrashlytics/upload-symbols -gsp lib/firebase/cause-commune-GoogleService-Info.plist -p ios dSYMs.zip
```

And :

```
ios/Pods/FirebaseCrashlytics/upload-symbols -gsp lib/firebase/thinkerview-GoogleService-Info.plist -p ios dSYMs.zip
```
