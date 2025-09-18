#!/usr/bin/env bash
# sys_report.sh - generate a basic system report

set -euo pipefail

echo "===== System Report ====="
echo "Date: $(date)"
echo

# OS / Kernel
echo ">> OS and Kernel:"
uname -a
echo

# Uptime / Load
echo ">> Uptime and Load:"
uptime
echo

# CPU info (first few lines)
echo ">> CPU Info:"
lscpu | grep -E 'Model name|Architecture|CPU\(s\)|Thread|Core'
echo

# Memory usage
echo ">> Memory Usage:"
free -h
echo

# Disk usage (root filesystem)
echo ">> Disk Usage (/):"
df -h /
echo

# Top CPU processes
echo ">> Top CPU Processes:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
echo

# IP addresses (IPv4)
echo ">> IP Addresses (IPv4):"
ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}'
echo

echo "===== End of Report ====="
