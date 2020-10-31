#!/bin/bash

set -euo pipefail

if [ -z "${DEPLOY_TOKEN}" ]; then
  echo "Error: Set DEPLOY_TOKEN first."
  exit 1
fi

APP_NAME="baby-sleep-time"

usage() {
  echo "$0 [-s SERIAL] [-m SLACK_MESSAGE]"
  exit 0
}

log() {
  echo "[$(date)] $@"
}

while getopts ":s:m:" o; do
  case "${o}" in
    s)
      SERIAL="${OPTARG}"
      ;;
    m)
      MESSAGE="${OPTARG}"
      ;;
    *)
      usage
      ;;
  esac
done

SERIAL="${SERIAL:-"$(date +"%Y%m%d_%H%M%S")"}"
MESSAGE="${MESSAGE:-"버그 수정"}"

log "Start to deploy"
log " - SERIAL=${SERIAL}"
log " - MESSAGE=${MESSAGE}"

# https://github.com/yingyeothon/binary-distribution-api
DEPLOY_SERVICE="https://api.yyt.life/d/${APP_NAME}"

build_and_upload() {
  local BUILD_NAME="$1"
  local BUILD_OUTPUT="$2"
  shift 2

  flutter build $@ && \
    curl -T "${BUILD_OUTPUT}" "$( \
      curl -s -XPUT \
        "${DEPLOY_SERVICE}/android/${BUILD_NAME}" \
        -H "X-Auth-Token: ${DEPLOY_TOKEN}" \
      | tr -d '"')" && \
    curl -s -XGET "${DEPLOY_SERVICE}?count=1" | jq -r '.platforms.android[].url'
}

BUILD_GRADLE="android/app/build.gradle"
ANDROID_MANIFEST="android/app/src/main/AndroidManifest.xml"

git restore -- "${BUILD_GRADLE}" "${ANDROID_MANIFEST}"

log "Build debug apk."
sed -i 's/me.hoppipolla.baby_sleep_time/me.hoppipolla.baby_sleep_time_debug/g' "${BUILD_GRADLE}"
sed -i 's/자장자장/자장자장_deubg/g' "${ANDROID_MANIFEST}"
DEBUG_APK="$(build_and_upload "${APP_NAME}-${SERIAL}-debug.apk" "build/app/outputs/flutter-apk/app-arm64-v8a-debug.apk" "apk --debug --split-per-abi --target-platform android-arm64" | tail -n1)"

log "Build release apk."
sed -i 's/me.hoppipolla.baby_sleep_time_debug/me.hoppipolla.baby_sleep_time/g' "${BUILD_GRADLE}"
sed -i 's/자장자장_deubg/자장자장/g' "${ANDROID_MANIFEST}"
RELEASE_APK="$(build_and_upload "${APP_NAME}-${SERIAL}-release.apk" "build/app/outputs/flutter-apk/app-arm64-v8a-release.apk" "apk --release --split-per-abi --target-platform android-arm64" | tail -n1)"

log "Build appbundle."
APPBUNDLE="$(build_and_upload "${APP_NAME}-${SERIAL}.aab" "build/app/outputs/bundle/release/app-release.aab" "appbundle --release" | tail -n1)"

log "Notify via Slack."
if [ ! -z "${SLACK_HOOK_URL}" ]; then
  MESSAGE_FILE="$(mktemp)"
  cat <<EOF > "${MESSAGE_FILE}"
*자장자장 새 버전 출시!* 👏👏👏
${MESSAGE}

  - <${DEBUG_APK}|DEBUG> 🎉
  - <${RELEASE_APK}|RELEASE> 🎉
  - <${APPBUNDLE}|APPBUNDLE> 🎉
EOF
  curl -XPOST "${SLACK_HOOK_URL}" \
    -H "Content-Type: application/json" \
    -d "{\"username\":\"앱 배포\",\"channel\":\"C0146N9AUGK\",\"icon_emoji\":\":man-running:\",\"text\":\"$(cat "${MESSAGE_FILE}")\"}"
  rm -f "${MESSAGE_FILE}"
fi
