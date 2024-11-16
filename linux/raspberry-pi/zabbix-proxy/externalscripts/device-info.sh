#!/bin/bash

# Function to print a section header
print_header() {
    echo "========================================="
    echo "$1"
    echo "========================================="
}

# Retrieve and display system information
print_header "SYSTEM INFORMATION"
echo "Hostname: $(hostname)"
echo "Device Model: $(cat /sys/devices/virtual/dmi/id/product_name 2>/dev/null || echo 'Unknown')"
echo "Manufacturer: $(cat /sys/devices/virtual/dmi/id/sys_vendor 2>/dev/null || echo 'Unknown')"
echo "Motherboard: $(cat /sys/devices/virtual/dmi/id/board_name 2>/dev/null || echo 'Unknown')"
echo "BIOS Version: $(cat /sys/devices/virtual/dmi/id/bios_version 2>/dev/null || echo 'Unknown')"

print_header "OPERATING SYSTEM"
echo "OS: $(uname -s)"
echo "Kernel Version: $(uname -r)"
echo "Architecture: $(uname -m)"
if command -v lsb_release &> /dev/null; then
    echo "Distribution: $(lsb_release -d | cut -f2)"
    echo "Codename: $(lsb_release -c | cut -f2)"
else
    echo "Distribution: $(cat /etc/os-release 2>/dev/null | grep '^PRETTY_NAME' | cut -d '=' -f2 | tr -d '\"' || echo 'Unknown')"
fi

print_header "FIRMWARE INFORMATION"
echo "Firmware Version: $(cat /sys/devices/virtual/dmi/id/uefi 2>/dev/null || echo 'Unknown')"

print_header "ADDITIONAL INFORMATION"
echo "Uptime: $(uptime -p)"
echo "Total Memory: $(free -h | grep Mem | awk '{print $2}')"
echo "CPU Model: $(grep 'model name' /proc/cpuinfo | head -1 | cut -d ':' -f2 | sed 's/^ *//')"
echo "Disk Usage: $(df -h / | awk 'NR==2 {print $3 " used out of " $2}')"

print_header "NETWORK INFORMATION"
echo "IP Address: $(hostname -I | awk '{print $1}')"
echo "MAC Address: $(ip link show | grep 'link/ether' | awk '{print $2}' | head -1)"
