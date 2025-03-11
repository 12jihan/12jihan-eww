#!/usr/bin/env zsh

get_sinks_json() {
  # Get the default sink
  default_sink=$(pactl info | grep 'Default Sink' | cut -d':' -f2 | xargs)

  # Create JSON array from sinks
  echo -n '['
  first=true
  pactl list short sinks | while IFS=$'\t' read -r index name module_id sample_spec state channels volume mute; do
    if [[ "$first" = true ]]; then
      first=false
    else
      echo -n ','
    fi

    # Check if this is the default sink
    is_default=false
    if [[ "$name" = "$default_sink" ]]; then
      is_default=true
    fi

    # Get a readable description
    description=$(pactl list sinks | grep -A1 "Name: $name" | grep Description | sed 's/Description: //' | sed 's/^\s*//')

    # Create JSON object for this sink
    echo -n "{\"index\":\"$index\",\"name\":\"$name\",\"description\":\"$description\",\"default\":$is_default}"
  done
  echo ']'
}

# Set default sink if argument provided
if [[ -n "$1" ]]; then
  pactl set-default-sink "$1"

  # Move all sink inputs to the new default sink
  sink_inputs=(${(f)"$(pactl list sink-inputs short | cut -f1)"})
  for input in $sink_inputs; do
    pactl move-sink-input "$input" "$1"
  done
fi

# Output JSON
get_sinks_json
