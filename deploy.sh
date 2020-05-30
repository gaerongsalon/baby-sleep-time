#!/bin/bash

if [ -z "${DEPLOY_TOKEN}" ]; then
  echo "Error: Set DEPLOY_TOKEN first."
  exit 1
fi

APP_NAME="baby-sleep-time"

usage() {
  echo "$0 [-s SERIAL] [-m SLACK_MESSAGE]"
  exit 0
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

echo "Start to deploy"
echo " - SERIAL=${SERIAL}"
echo " - MESSAGE=${MESSAGE}"

# https://github.com/yingyeothon/binary-distribution-api
DEPLOY_SERVICE="https://api.yyt.life/d/${APP_NAME}"

flutter build apk --release --split-per-abi --target-platform android-arm64 && \
  curl -T build/app/outputs/apk/release/app-arm64-v8a-release.apk "$( \
    curl -XPUT \
      "${DEPLOY_SERVICE}/android/${APP_NAME}-${SERIAL}.apk" \
      -H "X-Auth-Token: ${DEPLOY_TOKEN}" \
    | tr -d '"')" && \
  curl -XGET "${DEPLOY_SERVICE}?count=1" | jq -r '.platforms.android[].url' | tee .lastDeployed

if [ $? -ne 0 ]; then
  echo "Something wrong."
  exit 1
fi

LAST_DEPLOYED="$(cat .lastDeployed)"
if [ ! -z "${SLACK_HOOK_URL}" ]; then
  SLACK_MESSAGE="자장자장 새 버전 출시! 👏👏👏 <${LAST_DEPLOYED}|DOWNLOAD>"
  if [ ! -z "${MESSAGE}" ]; then
    SLACK_MESSAGE="${SLACK_MESSAGE}\n${MESSAGE}"
  fi
  curl -XPOST "${SLACK_HOOK_URL}" \
    -H "Content-Type: application/json" \
    -d "{\"username\":\"앱 배포\",\"channel\":\"C0146N9AUGK\",\"icon_emoji\":\":man-running:\",\"text\":\"${SLACK_MESSAGE}\"}"
fi

