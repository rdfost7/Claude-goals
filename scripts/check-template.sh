#!/usr/bin/env bash
# Verifies GOAL_SESSION_TEMPLATE.md contains every required section and the /goal line.
set -u
f="${1:-GOAL_SESSION_TEMPLATE.md}"
[ -f "$f" ] || { echo "FAIL: $f not found"; exit 1; }
fail=0
for h in "## Objective" "## Repo" "## Step 1: Start the cloud session" "## Step 2: Set permissions" \
         "## Step 3: Set the goal" "## Step 4: Work loop" "## Step 5: Handle interruptions" \
         "## Step 6: Deliver" "## Step 7: Report back" "## Hard limits" \
         "/goal <END STATE> is true, proven by <CHECK COMMAND>" "stop after <N> turns"; do
  if grep -qF -- "$h" "$f"; then echo "ok:   $h"; else echo "FAIL: missing '$h'"; fail=1; fi
done
[ $fail -eq 0 ] && echo "PASS: template complete" || echo "FAIL: template incomplete"
exit $fail
