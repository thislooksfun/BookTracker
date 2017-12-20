#!/bin/bash

beginswith() { case $2 in "$1"*) true;; *) false;; esac; }

shopt -s dotglob

versionModifiedAt=$(date -r versions +%s)
needsUpdate=false

processEntry() {
  if [[ "$1" == "versions" ]]; then return; fi
  if [[ "$1" == ".git" ]];     then return; fi
  if beginswith ".git/" "$1";  then return; fi
  
  if [ $(date -r "$1" +%s) -gt "$versionModifiedAt" ]; then
    needsUpdate=true
  fi
}

# Top level
for entry in *; do
  processEntry "$entry"
  if [[ $needsUpdate == true ]]; then
    break;
  fi
done

# Nested
if [[ $needsUpdate != true ]]; then
  for entry in **/*; do
    processEntry "$entry"
    if [[ $needsUpdate == true ]]; then
      break;
    fi
  done
fi

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