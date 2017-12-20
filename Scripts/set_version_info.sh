#!/bin/bash

versionModifiedAt=$(date -r versions +%s)
needsUpdate=false

for entry in **/*; do
  if [[ "$entry" != "versions" ]]; then
    if [ $(date -r "$entry" +%s) -gt "$versionModifiedAt" ]; then
      needsUpdate=true
      break;
    fi
  fi
done

if [[ $needsUpdate != true ]]; then
  echo "No update needed"
  exit 0
fi
echo "Updating version and build info"


buildPlist=${PROJECT_DIR}/${INFOPLIST_FILE}

# Update version from Git tag
git=$(sh /etc/profile; which git)
git_release_version=$("$git" describe --tags --always --abbrev=0)
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${git_release_version#*v}" "$buildPlist"

# Increment build number
buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$buildPlist")
buildNumber=$((0x$buildNumber))
buildNumber=$(($buildNumber + 1))
buildNumber=$(printf "%04X" $buildNumber)
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "$buildPlist"

echo -e "${git_release_version#*v}\n$buildNumber" > versions