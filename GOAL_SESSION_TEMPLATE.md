# Task: Run a goal-driven Claude Code cloud session until the goal resolves

Copy this file into a cloud session's first message and fill in every `<placeholder>`.

## Objective
<one sentence: what must be true when you're done>

## Repo
- GitHub repo: <owner/repo>
- Base branch: <branch>
- Work branch: claude/<short-name>

## Step 1: Start the cloud session
- If you have the Claude Code CLI, signed in with `claude auth login` (claude.ai account, not an API key):
  1. Make sure the base branch is pushed. The VM clones from GitHub, not from local files.
  2. Run: `claude --cloud "<objective>"`
- If you are already inside a cloud session, skip to Step 2.
- Requirements: a Pro, Max or Team plan, or an Enterprise premium seat. The Claude GitHub App must be installed on the repo, or `/web-setup` must have been run.

## Step 2: Set permissions
- Switch the session to auto mode. Without it, tool calls stop and wait for approval, and the goal stalls.

## Step 3: Set the goal
Send exactly one command, up to 4,000 characters:

```
/goal <END STATE> is true, proven by <CHECK COMMAND> exiting 0 with its output shown in the transcript; constraints: <WHAT MUST NOT CHANGE>; or stop after <N> turns and report status.
```

Rules for the condition:
- One measurable end state: test result, exit code, file count, empty queue.
- The proof must appear in the transcript. The evaluator reads the conversation only; it cannot run commands or open files.
- Always include a turn limit.

## Step 4: Work loop (repeat until the goal clears)
Each turn:
1. Make the smallest change that moves toward the end state.
2. Run the check command and let its full result print.
3. State progress against the condition and the turn limit in one line.
4. Do not end a turn without using a tool. Several tool-free turns in a row stop the loop.
5. Wait for long-running background jobs to finish before the turn ends. The evaluator skips turns that still have background work running.

## Step 5: Handle interruptions
- "Goal paused" (rate limit or usage limit): wait. It resumes when the limit resets, or when a new message arrives.
- "Goal cleared after an unrecoverable error": fix the cause (credits, context overflow, model unavailable), then send the same /goal again.
- Evaluator verdict "Impossible": stop and report why. Do not reword the goal to force a pass.
- Session expired from inactivity: reopen it. The conversation is restored, but background commands and loops are not. Rerun what is needed, then check `/goal`.

## Step 6: Deliver
1. Commit and push to the work branch.
2. Open a PR against the base branch. The description should cover: what changed, the final check output, and turns used.
3. Optional: enable Auto-fix on the PR, so later CI failures and review comments get handled.

## Step 7: Report back
Send a short report with:
- Final verdict: met, impossible, or stopped at the turn limit
- PR link
- Output of the final check command
- Anything left undone or uncertain

## Hard limits
- Never change files or behavior listed under constraints.
- Never edit tests or checks to make them pass unless the objective says to.
- If the objective is ambiguous before you start, ask once, then go with the most reasonable reading and write that reading down in the PR.
