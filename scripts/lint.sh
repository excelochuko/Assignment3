
#!/usr/bin/env bash

set -u

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT" || exit 1

echo "Running Bash syntax checks..."

failed=0
checked=0

for file in app/*.sh scripts/*.sh tests/*.sh; do
    [[ -f "$file" ]] || continue
    checked=$((checked + 1))

    if bash -n "$file"; then
        echo "PASS: $file"
    else
        echo "FAIL: $file"
        failed=1
    fi
done

if (( checked == 0 )); then
    echo "Error: no shell scripts found."
    exit 1
fi

if (( failed != 0 )); then
    echo "Lint failed."
    exit 1
fi

echo "Lint passed: $checked shell script(s) checked."
