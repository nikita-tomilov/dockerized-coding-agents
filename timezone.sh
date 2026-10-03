#!/bin/bash
# Source this file from a launcher. Use a timezone name rather than mounting
# /etc/localtime, which may not be accessible to Docker's VM on macOS.

agentshell_timezone() {
  local localtime timezone

  # An explicitly empty TZ means UTC, just as it does for libc.
  if [[ ${TZ+x} ]]; then
    printf '%s\n' "${TZ:-Etc/UTC}"
    return
  fi

  # Linux: /usr/share/zoneinfo/...; macOS: /var/db/timezone/zoneinfo/...
  localtime="$(readlink /etc/localtime 2>/dev/null)"
  case "$localtime" in
    */zoneinfo/*)
      timezone="${localtime#*/zoneinfo/}"
      timezone="${timezone#posix/}"
      timezone="${timezone#right/}"
      if [[ -n "$timezone" ]]; then
        printf '%s\n' "$timezone"
        return
      fi
      ;;
  esac

  # These also cover Linux systems where /etc/localtime is a regular file.
  timezone="$(timedatectl show --property=Timezone --value 2>/dev/null)"
  if [[ -n "$timezone" ]]; then
    printf '%s\n' "$timezone"
    return
  fi
  timezone="$(cat /etc/timezone 2>/dev/null)"
  if [[ -n "$timezone" ]]; then
    printf '%s\n' "$timezone"
    return
  fi

  printf '%s\n' 'Could not detect the host timezone; using Etc/UTC. Set TZ to override it.' >&2
  printf '%s\n' Etc/UTC
}

export TZ="$(agentshell_timezone)"
