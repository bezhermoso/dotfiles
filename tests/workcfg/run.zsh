#!/usr/bin/env zsh
# Runs every tests/workcfg/test_*.zsh. Exit 1 if any test fails.
set -u
cd "${0:a:h}"
source ./harness.zsh

typeset -i total_run=0 total_failed=0
for f in test_*.zsh; do
  print "── ${f}"
  TESTS_RUN=0 TESTS_FAILED=0
  source "./$f"
  _finalize_current
  (( total_run += TESTS_RUN, total_failed += TESTS_FAILED ))
done

print ""
if (( total_failed )); then
  print -u2 "✗ $total_failed of $total_run failed"
  exit 1
fi
print "✓ $total_run passed"
