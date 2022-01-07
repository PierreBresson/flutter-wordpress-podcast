.DEFAULT_GOAL := help

help: ## show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build-android-thinkerview: ## build android thinkerview
	flutter build appbundle --flavor thinkerview

build-android-causecommune: ## build android causecommune
	flutter build appbundle --flavor causecommune

run-android-thinkerview: ## run android thinkerview
	flutter clean
	flutter run --flavor thinkerview

run-android-causecommune: ## run android causecommune
	flutter clean
	flutter run --flavor causecommune

upload-dSYMs-thinkerview: ## upload dSYMs thinkerview
	ios/Pods/FirebaseCrashlytics/upload-symbols -gsp /path/to/thinkerview-GoogleService-Info.plist -p ios dSYMs