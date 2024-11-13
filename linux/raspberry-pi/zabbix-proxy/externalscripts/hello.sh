#!/bin/bash

# Define the log file path
LOG_FILE="/tmp/hello.log"

# Print a welcome message with the current date and time, and log it to the log file
echo "Hello, welcome to the system!" | tee -a "$LOG_FILE"
echo "Current date and time: $(date)" | tee -a "$LOG_FILE"