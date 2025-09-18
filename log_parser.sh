#!/usr/bin/env bash
# log_parser.sh — search a log for a regex with optional context + summary
# Usage:
#   ./log_parser.sh [-p PATTERN] [-o OUTFILE] [-c N] [-S] FILE
# Flags:
#   -p PATTERN   Regex to search for (default: "error", extended regex)
#   -o OUTFILE   Where to write matching output (default: "errors_found.log")
#   -c N         Context lines before/after matches (default: 0)
#   -S           Case-sensitive (default is case-insensitive)
#   -h           Show help
#
# Exit codes:
#   0 = at least one matching line found
#   1 = no matching lines found
#   2 = incorrect usage / invalid options

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: log_parser.sh [-p PATTERN] [-o OUTFILE] [-c N] [-S] FILE

Search FILE for PATTERN using extended regex. By default, search is
case-insensitive and writes matching lines to OUTFILE. Optional -c N
adds N lines of context before and after each match. The script exits
0 if any matches are found, else 1.

Options:
  -p PATTERN   Regex to search for (default: "error")
  -o OUTFILE   Output file to write matches (default: "errors_found.log")
  -c N         Show N context lines (default: 0)
  -S           Case-sensitive (default is case-insensitive)
  -h           Show this help
USAGE
}

# Defaults
pattern="error"
outfile="errors_found.log"
context=0
case_sensitive=0

# Parse flags
while getopts ":p:o:c:Sh" opt; do
  case "$opt" in
    p) pattern=$OPTARG ;;
    o) outfile=$OPTARG ;;
    c) context=$OPTARG ;;
    S) case_sensitive=1 ;;
    h) usage; exit 0 ;;
    :) echo "Error: -$OPTARG requires an argument" >&2; usage; exit 2 ;;
    \?) echo "Error: invalid option -$OPTARG" >&2; usage; exit 2 ;;
  esac
done
shift $((OPTIND - 1))

# Validate positional FILE
file=${1:-}
if [[ -z "$file" ]]; then
  echo "Error: missing FILE" >&2
  usage
  exit 2
fi
if [[ ! -f "$file" ]]; then
  echo "Error: no such file: $file" >&2
  exit 2
fi

# Validate context is a non-negative integer
if ! [[ "$context" =~ ^[0-9]+$ ]]; then
  echo "Error: -c N must be a non-negative integer (got: $context)" >&2
  exit 2
fi

# Build grep args
grep_args=(-E)
(( case_sensitive == 0 )) && grep_args+=(-i)

# For output (may include context)
grep_out_args=("${grep_args[@]}")
(( context > 0 )) && grep_out_args+=(-C "$context")

# 1) Write matches (with optional context) to outfile.
#    Important: grep returns 1 when no lines match; that's not a fatal error for us.
grep "${grep_out_args[@]}" -- "$pattern" "$file" > "$outfile" || true

# 2) Count only MATCHING LINES (not context lines), for a truthful summary/exit code.
#    We run a second grep without -C and with -c to get just the match count.
match_count=$(grep "${grep_args[@]}" -c -- "$pattern" "$file" || true)

# 3) Optional: also report how many lines were written to outfile (context inflates this).
lines_written=$(wc -l < "$outfile")

# Summary
echo "matches=$match_count  written_lines=$lines_written  pattern=$pattern  out=$outfile  file=$file"

# Exit 0 if any matches, else 1
if (( match_count > 0 )); then
  exit 0
else
  exit 1
fi
