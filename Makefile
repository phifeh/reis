.PHONY: build deploy

build:
	flutter build apk

deploy: build
	mkdir -p "$(GOOGLE_DRIVE_PATH)/apps"
	cp build/app/outputs/flutter-apk/app-release.apk "$(GOOGLE_DRIVE_PATH)/apps/reis.apk"
	@echo "APK deployed to $(GOOGLE_DRIVE_PATH)/apps/reis.apk"
