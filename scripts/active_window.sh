#!/usr/bin/env zsh

# Get active window information
window_info=$(hyprctl activewindow -j)

# Extract title and class
info_json=$(echo $window_info | jq)
title=$(echo $window_info | jq -r '.title')
class=$(echo $window_info | jq -r '.class')
class=${class##*.}
class="${(C)class}"

# Check if title is empty and if "title" argument is passed
if [[ "$1" == "title" ]]; then
  if [[ -n "$title" ]]; then
    echo $title
  else
    echo $class
  fi
else
  echo $info_json
fi
