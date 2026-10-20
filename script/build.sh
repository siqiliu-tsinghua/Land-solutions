#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
build_dir="$project_root/build"
temp_dir="$project_root/temp"

if ! command -v xelatex >/dev/null 2>&1; then
  printf 'XeLaTeX is required to build the book.\n' >&2
  exit 127
fi

mkdir -p "$build_dir" "$temp_dir"
export TMPDIR="$temp_dir"
export TMP="$temp_dir"
export TEMP="$temp_dir"
export TEXMFVAR="$temp_dir/texmf-var"
export TEXMFCONFIG="$temp_dir/texmf-config"

cd -- "$project_root/src"
for pass in 1 2; do
  pass_log="$build_dir/xelatex-pass-$pass.log"
  if ! xelatex -no-shell-escape -interaction=nonstopmode -halt-on-error \
      -file-line-error -output-directory="$build_dir" main.tex >"$pass_log" 2>&1; then
    cat -- "$pass_log" >&2
    exit 1
  fi
done

printf 'Built %s\n' "$build_dir/main.pdf"
