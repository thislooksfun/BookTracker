#!/bin/bash

git=$(sh /etc/profile; which git)
number_of_commits=$("$git" rev-list HEAD --count)
git_hash=$("$git" rev-parse --short HEAD)



echo "Buildnumber and Date script"
buildPlist=${PROJECT_DIR}/${INFOPLIST_FILE}
echo "$buildPlist"

# update the properties for your <project>-Info.plist
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${git_release_version#*v}" "$buildPlist"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $git_hash" $buildPlist