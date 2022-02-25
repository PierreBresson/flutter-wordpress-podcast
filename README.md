# Flutter Wordpress Podcast

Podcast white label app based on Wordpress API using Flutter framework.

[![ko-fi](https://www.ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/P5P813IQT)

## Preview

![screenshot](https://github.com/PierreBresson/flutter-wordpress-podcast/blob/main/preview.png)

## Apps

[Thinkerview](https://www.thinkerview.com/) - [Android](https://play.google.com/store/apps/details?id=com.thinkerview&hl=fr) - [iOS](https://apps.apple.com/us/app/thinkerview/id1406076265?ls=1)

[Cause Commune](https://cause-commune.fm/) - [Android](https://play.google.com/store/apps/details?id=com.cause.commune) - [iOS](https://apps.apple.com/us/app/cause-commune/id1458650964?ls=1)

## Roadmap

Already existing and planned features.

- [x] Dark mode support
- [x] Test widgets and cubits
- [x] Recommended books for Thinkerview - markdown screen
- [x] Play audio in the background and respond to controls on the lockscreen, media notification, headset
- [x] Audio playback when leaving app
- [x] Search
- [x] Env config / scripts - white label apps
- [x] Log crash/bugs to Sentry
- [x] Image caching
- [ ] Stream live radio
- [ ] Refactor into smaller widgets
- [ ] Tests
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

Create `.env` file with `APP=causecommune` or `APP=thinkerview` inside and `DSN=yourSecretDSNfromSentry`.

### Run the app

`flutter pub get`

Android :

`flutter clean && flutter run --flavor thinkerview`

`flutter clean && flutter run --flavor causecommune`

iOS :

`flutter run --flavor CauseCommune`

`flutter run --flavor Thinkerview`

MacOS :

Since flavors aren't supported by Flutter on MacOS, there are some manual tasks in order to run and archive the app.

In `Project` -> `Runner` -> `Info` -> `Configurations` select for both Debug & Release either `Cause Commune` or `Thinkerview` in the Runner configuration set. Then `Clean Build Folder` inside `Product` menu of Xcode, run `pod install`. Don't forget to change the `Bundle Identifer` and the `Provisioning Profile` plus `APP` in env file.

### Build app

Android:

`flutter build appbundle --flavor thinkerview`

`flutter build appbundle --flavor causecommune`

iOS and MacOS:

Select project and archive on Xcode or :

`flutter build ios --flavor=Thinkerview`

`flutter build ios --flavor=CauseCommune`
