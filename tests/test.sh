
#!/usr/bin/env bash

set -u

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT" || exit 1

APP="./app/app.sh"
passed=0
failed=0

run_test() {
    local description="$1"
    shift

    if "$@"; then
        echo "PASS: $description"
        passed=$((passed + 1))
    else
        echo "FAIL: $description"
        failed=$((failed + 1))
    fi
}

check_exit_code() {
    local expected="$1"
    shift

    local actual=0
    "$@" >/dev/null 2>&1 || actual=$?

    if [[ "$actual" -eq "$expected" ]]; then
        return 0
    fi

    echo "Expected exit code $expected, got $actual" >&2
    return 1
}

run_test "Help command" "$APP" help
run_test "System information command" "$APP" system-info
run_test "Missing command returns exit code 2" \
    check_exit_code 2 "$APP"
run_test "Invalid text port returns exit code 2" \
    check_exit_code 2 "$APP" check-port localhost abc
run_test "Port zero returns exit code 2" \
    check_exit_code 2 "$APP" check-port localhost 0
run_test "Port 65536 returns exit code 2" \
    check_exit_code 2 "$APP" check-port localhost 65536
run_test "Unknown command returns exit code 2" \
    check_exit_code 2 "$APP" unknown-command

echo
echo "Test results: $passed passed, $failed failed."

if (( failed > 0 )); then
    exit 1
fi

echo "All tests passed."
