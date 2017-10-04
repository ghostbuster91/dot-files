#!/bin/sh
# from https://raw.githubusercontent.com/termux/termux-packages/master/scripts/setup-android-sdk.sh
set -e -u

# Install desired parts of the Android SDK:
ANDROID_HOME="${HOME}/lib/android-sdk"

if [ ! -d $ANDROID_HOME ]; then
	mkdir -p $ANDROID_HOME
	cd $ANDROID_HOME/..
	rm -Rf `basename $ANDROID_HOME`

	# https://developer.android.com/studio/index.html#command-tools
	# The downloaded version below is 26.0.1.:
	curl --fail --retry 3 \
		-o tools.zip \
		https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip
	rm -Rf android-sdk
	unzip -q tools.zip -d android-sdk
	rm tools.zip
fi

mkdir -p $ANDROID_HOME/licenses
echo -e -n "\n8933bad161af4178b1185d1a37fbf41ea5269c55" > $ANDROID_HOME/licenses/android-sdk-license
# The android-16 platform is used in the ecj package:
$ANDROID_HOME/tools/bin/sdkmanager "build-tools;26.0.1" "platforms;android-26" "platforms;android-16"
