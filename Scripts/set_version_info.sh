#!/bin/bash

git=$(sh /etc/profile; which git)
git_hash=$("$git" rev-parse --short HEAD)
git_release_version=$("$git" describe --tags --always --abbrev=0)



echo "Buildnumber and Date script"
buildPlist=${PROJECT_DIR}/${INFOPLIST_FILE}
echo "$buildPlist"

# update the properties for your <project>-Info.plist
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${git_release_version#*v}" "$buildPlist"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $git_hash" $buildPlist