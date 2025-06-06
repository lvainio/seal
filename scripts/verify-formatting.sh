#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Find all .cpp and .h files
dirs=($REPO_ROOT/src $REPO_ROOT/tests)
files=$(find "${dirs[@]}" -type f \( -name '*.cpp' -o -name '*.h' \))

format_issues_found=0
for file in $files; do
  if ! diff -q <(clang-format -style=file "$file") "$file" >/dev/null; then
    echo "Formatting issue found in: $file"
    format_issues_found=1
  fi
done

if (( $format_issues_found )); then
  echo "ERROR: Some files are not properly formatted. Please run clang-format."
  exit 1
else
  echo "All files are properly formatted."
  exit 0
fi
