#!/bin/sh

set -o pipefail && \
  xcodebuild clean build test \
  -workspace ./Example/Swiftilities.xcworkspace \
  -scheme Swiftilities \
  -sdk iphonesimulator \
  -destination "platform=iOS Simulator,name=iPhone 7,OS=10.1" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY= \
  | xcpretty
