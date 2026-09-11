#!/usr/bin/env bash
set -euo pipefail

log() { echo "[worktree-review] $*" >&2; }

if [ $# -lt 1 ]; then
  log "ERROR: branch name required"
  log "Usage: git wr <branch>"
  exit 1
fi

NAME="$1"
SAFE_NAME="${NAME//\//-}"
REVIEW_FILE="$HOME/${SAFE_NAME}-review.txt"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAIN_TREE=$(git rev-parse --show-toplevel)

log "Fetching origin/$NAME"
git -C "$MAIN_TREE" fetch origin "$NAME" >&2

# Ensure local branch matches origin/$NAME so worktree-create's fallback path picks it up.
# If branch is checked out in a worktree, skip reset — create script will reuse that worktree.
if ! git -C "$MAIN_TREE" show-ref --verify --quiet "refs/heads/$NAME"; then
  log "Creating local branch '$NAME' tracking origin/$NAME"
  git -C "$MAIN_TREE" branch "$NAME" "origin/$NAME" >&2
elif git -C "$MAIN_TREE" worktree list --porcelain | grep -q "^branch refs/heads/$NAME$"; then
  log "Branch '$NAME' checked out in existing worktree — skipping reset"
else
  log "Resetting local '$NAME' to origin/$NAME"
  git -C "$MAIN_TREE" branch -f "$NAME" "origin/$NAME" >&2
fi

# Delegate to worktree-create.sh — handles worktree, gitignore, .worktree-copy, deps
PRE_EXISTING=0
PROBE_PATH=$(git -C "$MAIN_TREE" worktree list --porcelain | awk -v b="refs/heads/$NAME" '
  /^worktree / { wt = $2 }
  $0 == "branch " b { print wt; exit }
')
[ -n "$PROBE_PATH" ] && PRE_EXISTING=1

WORKTREE_PATH=$("$SCRIPT_DIR/worktree-create.sh" "$NAME")

cd "$WORKTREE_PATH"

if [ "$PRE_EXISTING" = 1 ]; then
  log "Fast-forwarding existing worktree to origin/$NAME"
  if ! git merge --ff-only "origin/$NAME" >&2; then
    log "WARNING: ff-only merge failed — worktree has diverged or local changes; reviewing current state"
  fi
fi

log "Launching claude headless review in $WORKTREE_PATH"
log "Review will be saved to $REVIEW_FILE"
claude -p "use the @pr-code-reviewer agent to review the current feature branch." | tee "$REVIEW_FILE"
