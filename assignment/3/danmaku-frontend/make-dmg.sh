#!/usr/bin/env bash

if [[ "$#" != 2 ]];then
    echo "Usage: $(basename $0) <app-file> <background-png>"
    exit 1
fi

appFile="$1"
backgroundFile="$2"

appFileName="$(basename $appFile)"
backgroundFileName="$(basename $backgroundFile)"
volName="Danmaku"

echo ":: [Stage 1] Creating read/write precursor dmg"
dmgBuildDir=".$$.install"
rwDmg="danmaku-precursor.dmg"

rm -f "${volName}.dmg"
mkdir "$dmgBuildDir"
mkdir "$dmgBuildDir/.hidden"
(cd "$dmgBuildDir" && ln -s /Applications .)
cp -r "$appFile" "$dmgBuildDir"
cp "$backgroundFile" "$dmgBuildDir/.hidden"
chflags hidden "$dmgBuildDir/.hidden"

hdiutil create -volname "$volName" -srcfolder "$PWD/$dmgBuildDir" -ov -format UDRW -fs HFS+ "$rwDmg"

echo ":: [Stage 2] Mounting precursor dmg"
hdiutil mount "$rwDmg" 1>/dev/null

echo ":: [Stage 2] Applying background: 600x400"
backgroundWidth=600
backgroundHeight=400

topLeftX=100
topLeftY=100
let bottomRightX=$backgroundWidth+$topLeftX
let bottomRightY=$backgroundHeight+$topLeftY
let centery=($backgroundHeight/2)-32

let centerXAppFile=$backgroundWidth/4
let centerXApplications=$backgroundWidth/4*3

echo ":: [Stage 2] Running AppleScript"
echo '
tell application "Finder"
    tell disk "'$volName'"
       set current view of container window to icon view
       set theViewOptions to the icon view options of container window
       set icon size of theViewOptions to 128
       set background picture of theViewOptions to file ".hidden:'$backgroundFileName'"
       open
       set toolbar visible of container window to false
       set statusbar visible of container window to false
       set the extension hidden of item "'$appFileName'" to true
       set the bounds of container window to {'$topLeftX', '$topLeftY', '$bottomRightX', '$bottomRightY'}
       set position of item "'$appFileName'" of container window to {'$centerXAppFile', '$centery'}
       set position of item "'Applications'" of container window to {'$centerXApplications', '$centery'}
       close
       open
       update without registering applications
       delay 3
       close
       eject
    end tell
end tell
' | osascript

echo ":: [Stage 2] Blessing"
sleep 3
diskutil eject "/Volumes/$volName" 2>/dev/null
hdiutil mount "$rwDmg" 1>/dev/null

bless --folder "/Volumes/$volName" --openfolder "/Volumes/$volName"
diskutil eject "/Volumes/$volName" 1>/dev/null
sleep 3

echo ":: [Stage 2] Creating the final read only dmg"
hdiutil convert "$rwDmg" -format UDZO -ov -o "${volName}.dmg"

echo ":: [Stage 2] Done"
rm -rf "$dmgBuildDir"
rm "$rwDmg"
