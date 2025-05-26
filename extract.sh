#!/bin/bash

# Logging functions with Unicode symbols
COLOR_INFO="\033[34m"    # Blue
COLOR_ERROR="\033[31m"   # Red
COLOR_SUCCESS="\033[32m" # Green
COLOR_RESET="\033[0m"

SYMBOL_INFO="ℹ "
SYMBOL_ERROR="✖ "
SYMBOL_SUCCESS="✓ "

print_info() {
  printf "${COLOR_INFO}${SYMBOL_INFO}$1${COLOR_RESET}\n" "${@:2}"
}

print_error() {
  printf "${COLOR_ERROR}${SYMBOL_ERROR}$1${COLOR_RESET}\n" "${@:2}"
}

print_success() {
  printf "${COLOR_SUCCESS}${SYMBOL_SUCCESS}$1${COLOR_RESET}\n" "${@:2}"
}

verify_firmware_path() {
  if [ -z "$1" ]; then
    print_error "No firmware file path argument provided."
    exit 1
  fi

  local firmware_path="$1"

  if [ ! -e "$firmware_path" ]; then
    print_error "Firmware file does not exist: %s" "$firmware_path"
    exit 1
  fi

  if [ ! -f "$firmware_path" ]; then
    print_error "Firmware path is not a regular file: %s" "$firmware_path"
    exit 1
  fi

  if [ ! -r "$firmware_path" ]; then
    print_error "Firmware file is not readable: %s" "$firmware_path"
    exit 1
  fi

  print_success "Firmware file verified: %s" "$firmware_path"
}

verify_output_dir() {
  local output_dir="/data/results"

  if [ ! -e "$output_dir" ]; then
    print_error "Output directory does not exist: %s" "$output_dir"
    exit 1
  fi

  if [ ! -d "$output_dir" ]; then
    print_error "Output path is not a directory: %s" "$output_dir"
    exit 1
  fi

  if [ ! -w "$output_dir" ]; then
    print_error "Output directory is not writable: %s" "$output_dir"
    exit 1
  fi

  print_success "Output directory verified: %s" "$output_dir"
}

# Run verifications
verify_firmware_path "$1"
verify_output_dir

firmware_path="$1"
firmware_name="$(basename "$firmware_path")"
output_dir="/data/results"

print_info "Running dumper script on firmware: %s" "$firmware_path"
./dumper.sh "$firmware_path"

if [ $? -ne 0 ]; then
  print_error "dumper.sh encountered an error."
  exit 1
fi

print_success "Firmware successfully processed by dumper.sh"

if [ ! -d "/opt/DumprX/out" ]; then
  print_error "Expected output directory '/opt/DumprX/out' was not found."
  exit 1
fi

target_name="${firmware_name%.*}_output"
target_path="$output_dir/$target_name"

print_info "Moving output to: %s" "$target_path"
mv /opt/DumprX/out "$target_path"

print_info "Changing ownership to UID:GID 1000:1000 recursively"
chown -R 1000:1000 "$target_path"

print_success "Output moved and ownership updated."
