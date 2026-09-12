#!/usr/bin/env bash
set -uo pipefail
# Deliberately no -e: a failed uv sync should still let us return (and log it)
# rather than aborting the whole hook silently.

log() { echo "[worktree-bootstrap] $*" >&2; }

errExit() {
  log "ERROR: $*"
  exit 1
}

# Require jq
command -v jq >/dev/null || errExit "jq required"

# herdr passes the event payload in HERDR_PLUGIN_EVENT_JSON, not stdin.
[ -n "${HERDR_PLUGIN_EVENT_JSON:-}" ] || errExit "HERDR_PLUGIN_EVENT_JSON not set"

WORKTREE_PATH=$(jq -r '.data.worktree.path' <<< "$HERDR_PLUGIN_EVENT_JSON")
BRANCH=$(jq -r '.data.worktree.branch' <<< "$HERDR_PLUGIN_EVENT_JSON")
MAIN_TREE=$(jq -r '.data.workspace.worktree.repo_root' <<< "$HERDR_PLUGIN_EVENT_JSON")

[ -n "$WORKTREE_PATH" ] && [ "$WORKTREE_PATH" != "null" ] || errExit "missing worktree path in event payload"
[ -n "$MAIN_TREE" ] && [ "$MAIN_TREE" != "null" ] || errExit "missing repo_root in event payload"

log "worktree.created: branch=$BRANCH path=$WORKTREE_PATH repo_root=$MAIN_TREE"

# Idempotency — herdr has already created $WORKTREE_PATH by the time we run, so
# (unlike worktree-create.sh) we can't key off the dir existing. Key off the venv
# instead: if setup already ran once, don't redo it.
if [ -d "$WORKTREE_PATH/.venv" ]; then
  log "Virtualenv already present at $WORKTREE_PATH/.venv — skipping bootstrap"
  exit 0
fi

# Gitignore safety — ensure the worktree dir is ignored
dir_rel="$(dirname "${WORKTREE_PATH#$MAIN_TREE/}")"
if [ "$dir_rel" != "." ] && ! git -C "$MAIN_TREE" check-ignore -q "$dir_rel" 2>/dev/null; then
  log "Adding $dir_rel/ to .gitignore"
  echo "$dir_rel/" >> "$MAIN_TREE/.gitignore"
fi

# Copy gitignored files per .worktree-copy manifest
if [ -f "$MAIN_TREE/.worktree-copy" ]; then
  log "Copying files per .worktree-copy"
  while IFS= read -r pattern; do
    [[ -z "$pattern" || "$pattern" == \#* ]] && continue
    for file in $MAIN_TREE/$pattern; do
      [ -e "$file" ] || continue
      rel="${file#$MAIN_TREE/}"
      mkdir -p "$(dirname "$WORKTREE_PATH/$rel")"
      cp -r "$file" "$WORKTREE_PATH/$rel"
    done
  done < "$MAIN_TREE/.worktree-copy"
fi

# --- Python dependency setup (auto-detect; Python only for now) ---
cd "$WORKTREE_PATH" || errExit "cannot cd to $WORKTREE_PATH"

PY_VER="3.11"

if [ -f "pyproject.toml" ]; then
  log "Python project detected (pyproject.toml)"
  uv venv -p "$PY_VER" >&2
  uv sync --all-extras -p "$PY_VER" >&2
  if [ -d ".venv" ]; then
    log "Virtualenv ready at $WORKTREE_PATH/.venv (Python $PY_VER)"
  else
    log "WARNING: no .venv created in worktree"
  fi
elif ls requirements*.txt 1>/dev/null 2>&1; then
  log "Python project detected (requirements.txt)"
  uv venv -p "$PY_VER" >&2
  req_args=()
  for f in requirements*.txt; do req_args+=(-r "$f"); done
  uv pip install "${req_args[@]}" >&2
else
  log "No recognized Python project file — skipping dependency setup"
fi
