#!/usr/bin/env bash

set -e

if [[ "$#" != 1 ]]; then
    echo "Usage: $(basename $0) <logo-png>"
    echo "If success, danmaku.app is created."
    exit 1
fi

buildDir="target/"
iconPng="$1"

echo ":: Compiling Rust"
cargo build --release

workDir=".$$.danmaku.app.build"
contentDir="$workDir/Contents"

if [[ ! -d "$buildDir" ]]; then
    echo "Fatal error: $buildDir does not exist."
    exit 1
fi

if [[ ! -f "$iconPng" ]]; then
    echo "Fatal error: $iconPng does not exist."
    exit 1
fi

echo ":: Initializing application structure"
mkdir -m 755 "$workDir"
mkdir -m 755 "$contentDir"
mkdir -m 755 "$contentDir/MacOS"
mkdir -m 755 "$contentDir/Resources"

echo ":: Converting application logo"
mkdir .$$.iconset

sips -z 16 16 "$iconPng" --out .$$.iconset/icon_16x16.png
sips -z 32 32 "$iconPng" --out .$$.iconset/icon_16x16@2x.png
sips -z 32 32 "$iconPng" --out .$$.iconset/icon_32x32.png
sips -z 64 64 "$iconPng" --out .$$.iconset/icon_32x32@2x.png
sips -z 128 128 "$iconPng" --out .$$.iconset/icon_128x128.png
sips -z 256 256 "$iconPng" --out .$$.iconset/icon_128x128@2x.png
sips -z 256 256 "$iconPng" --out .$$.iconset/icon_256x256.png
sips -z 512 512 "$iconPng" --out .$$.iconset/icon_256x256@2x.png
sips -z 512 512 "$iconPng" --out .$$.iconset/icon_512x512.png
sips -z 1024 1024 "$iconPng" --out .$$.iconset/icon_512x512@2x.png

iconutil -c icns .$$.iconset -o "$contentDir/Resources/DanmakuLogo.icns"
rm -rf .$$.iconset

echo ":: Filling application Info.plist"
cat > "$contentDir/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleAllowMixedLocalizations</key>
	<true/>
	<key>CFBundleDevelopmentRegion</key>
	<string>English</string>
	<key>CFBundleExecutable</key>
	<string>wrapper</string>
	<key>CFBundleIconFile</key>
	<string>DanmakuLogo</string>
	<key>CFBundleIdentifier</key>
	<string>org.covscript.env</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>CovScript</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
    <key>CFBundleVersion</key>
	<string>${csFullVersion}</string>
	<key>CFBundleShortVersionString</key>
	<string>${csDisplayVersion}</string>
	<key>CFBundleSignature</key>
	<string>????</string>
	<key>CFBundleSupportedPlatforms</key>
	<array>
		<string>MacOSX</string>
	</array>
	<key>CFBundleURLTypes</key>
	<array/>
	<key>DTCompiler</key>
	<string>com.apple.compilers.llvm.clang.1_0</string>
	<key>DTPlatformBuild</key>
	<string>10L213p</string>
	<key>DTPlatformName</key>
	<string>macosx</string>
	<key>DTPlatformVersion</key>
	<string>10.14</string>
	<key>DTSDKBuild</key>
	<string>18A371</string>
	<key>DTSDKName</key>
	<string>macosx10.14internal</string>
	<key>DTXcode</key>
	<string>1000</string>
	<key>DTXcodeBuild</key>
	<string>10L213p</string>
	<key>LSMinimumSystemVersion</key>
	<string>10.6</string>
	<key>LSUIElement</key>
	<true/>
</dict>
</plist>

EOF

echo ":: Creating warpper scripts"
cat > "$contentDir/MacOS/wrapper" << EOF
#!/usr/bin/osascript

set selfPath to POSIX path of ((path to me as text) & "::")
set command to ("exec " & selfPath & "bootstrap " & selfPath)

do shell script command

EOF

cat > "$contentDir/MacOS/bootstrap" << EOF
#!/bin/bash

selfDir="\$@"
open -a Terminal.app "\${selfDir}/launcher"

EOF

cat > "$contentDir/MacOS/launcher" << EOF
#!/bin/bash

clear
selfDir="\$(cd \$(dirname \$0); pwd)"
danmakuDir="\${selfDir}/danmaku"

export PATH="\${PATH}:\${danmakuDir}/bin"
export LD_LIBRARY_PATH="\${LD_LIBRARY_PATH}:\${danmakuDir}/lib"

bin="\${danmakuDir}/bin/danmaku"

exec "\${bin}"

EOF

chmod 755 "$contentDir/MacOS/wrapper"
chmod 755 "$contentDir/MacOS/bootstrap"
chmod 755 "$contentDir/MacOS/launcher"

echo ":: Copying binaries and libraries"
mkdir -p "$contentDir/MacOS/danmaku/bin"
mkdir -p "$contentDir/MacOS/danmaku/lib"
cp -r "$buildDir/release/danmaku-frontend" "$contentDir/MacOS/danmaku/bin/danmaku"
chmod 755 "$contentDir/MacOS/danmaku/bin/danmaku"

echo ":: Done"
rm -rf "danmaku.app"
mv "$workDir" "danmaku.app"

