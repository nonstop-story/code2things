#!/bin/bash

set -e

cd $(dirname $(readlink -f $0))
./make-app.sh app_icon.png
./make-dmg.sh danmaku.app app_bg.png

