#!/bin/bash

sites_dir=`dirname "$0"`/../sites
pro=/home/p/pro

sites=(
  nechifor-site nechifor-site
)

excludes=(
  --exclude .git
  --exclude .idea
  --exclude '*~'
  --exclude private
  --exclude screenshot.png
  --exclude readme.md
  --exclude browserify
  --exclude web-build-tools
)

mkdir -p $sites_dir 2>/dev/null

for (( i = 0; i < ${#sites[@]}; i+=2 )) {
  rsync -a --del ${excludes[@]} "$pro/${sites[$i]}/" "$sites_dir/${sites[$i+1]}/"
}

war_file="$pro/Nechifor/dist/Nechifor.war"
if [ ! -f "$war_file" ]; then
  echo "WAR file missing. Was the project built?"
  exit 1
fi
cp "$war_file" "$sites_dir"
