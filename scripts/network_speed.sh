#!/usr/bin/env zsh

# Calculate network speed using /proc/net/dev
INTERFACE="enp4s0"
RX_PREV=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
TX_PREV=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
sleep 1
RX_CURR=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
TX_CURR=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)

RX_DIFF=$((RX_CURR - RX_PREV)) # KB/s
TX_DIFF=$((TX_CURR - TX_PREV)) # KB/s

# Convert bytes to megabytes (1 MB = 1024 * 1024 bytes)
RX_SPEED=$(echo "scale=2; $RX_DIFF / 1048576" | bc)
TX_SPEED=$(echo "scale=2; $TX_DIFF / 1048576" | bc)

# Output the result in MB/s
echo "  ${RX_SPEED} MB/s  ${TX_SPEED} MB/s"
