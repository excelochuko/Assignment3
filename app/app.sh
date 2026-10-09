#!/usr/bin/env bash

set -u

show_help() {
    cat <<'EOF'
DevOps Diagnostic CLI

Usage:
  ./app/app.sh help
  ./app/app.sh system-info
  ./app/app.sh check-port HOST PORT

Commands:
  help                    Show this help message
  system-info             Display system information
  check-port HOST PORT    Check whether a TCP port is reachable
EOF
}

system_info() {
    echo "Hostname: $(hostname)"
    
    if [[ -r /etc/os-release ]]; then
        . /etc/os-release
        echo "Operating System: ${PRETTY_NAME:-Unknown}"
    else
        echo "Operating System: Unknown"
    fi

    echo "Kernel: $(uname -r)"
    echo "Uptime: $(uptime -p 2>/dev/null || uptime)"
}

check_port() {
    local host="${1:-}"
    local port="${2:-}"

    if [[ -z "$host" || ! "$port" =~ ^[0-9]+$ ]]; then
        echo "Error: provide a host and a numeric port." >&2
        return 2
    fi

    if (( port < 1 || port > 65535 )); then
        echo "Error: port must be between 1 and 65535." >&2
        return 2
    fi

    if timeout 3 bash -c 'echo > /dev/tcp/"$1"/"$2"' _ "$host" "$port" 2>/dev/null; then
        echo "Port $port on $host is reachable."
        return 0
    else
        echo "Port $port on $host is not reachable."
        return 1
    fi
}

case "${1:-}" in
    help)
        show_help
        ;;
    system-info)
        system_info
        ;;
    check-port)
        if [[ $# -ne 3 ]]; then
            echo "Error: usage: check-port HOST PORT" >&2
            exit 2
        fi
        check_port "$2" "$3"
        exit $?
        ;;
    "")
        echo "Error: a command is required. Run './app/app.sh help'." >&2
        exit 2
        ;;
    *)
        echo "Error: unknown command '$1'." >&2
        echo "Run './app/app.sh help' for usage." >&2
        exit 2
        ;;
esac
