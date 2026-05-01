#!/usr/bin/env bash
set -euo pipefail

log() { echo "[worktree-create] $*" >&2; }

# Require jq
command -v jq >/dev/null || { log "ERROR: jq required"; exit 1; }

# Dual-mode input: CLI argument (git alias) or JSON stdin (hook)
if [ $# -ge 1 ]; then
  NAME="$1"
  CWD="$(pwd)"
else
  input=$(cat)
  NAME=$(echo "$input" | jq -r '.name')
  CWD=$(echo "$input" | jq -r '.cwd')
fi

# Resolve project root
MAIN_TREE=$(git -C "$CWD" rev-parse --show-toplevel)

# Directory selection: .worktrees > worktrees > default .worktrees
if [ -d "$MAIN_TREE/.worktrees" ]; then
  WORKTREE_DIR="$MAIN_TREE/.worktrees"
elif [ -d "$MAIN_TREE/worktrees" ]; then
  WORKTREE_DIR="$MAIN_TREE/worktrees"
else
  WORKTREE_DIR="$MAIN_TREE/.worktrees"
  mkdir -p "$WORKTREE_DIR"
fi

WORKTREE_PATH="$WORKTREE_DIR/$NAME"

# Idempotency — if worktree already exists, return path immediately
if [ -d "$WORKTREE_PATH" ]; then
  log "Worktree already exists at $WORKTREE_PATH"
  echo "$WORKTREE_PATH"
  exit 0
fi

# Gitignore safety — ensure worktree dir is ignored
dir_rel="${WORKTREE_DIR#$MAIN_TREE/}"
if ! git -C "$MAIN_TREE" check-ignore -q "$dir_rel" 2>/dev/null; then
  log "Adding $dir_rel/ to .gitignore"
  echo "$dir_rel/" >> "$MAIN_TREE/.gitignore"
fi

# Create worktree (fallback if branch already exists)
log "Creating worktree: $WORKTREE_PATH (branch: $NAME)"
if ! git -C "$MAIN_TREE" worktree add "$WORKTREE_PATH" -b "$NAME" 2>&1 >&2; then
  log "Branch '$NAME' may already exist, trying without -b"
  git -C "$MAIN_TREE" worktree add "$WORKTREE_PATH" "$NAME" >&2
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

# --- Project/dependency setup (auto-detect) ---
cd "$WORKTREE_PATH"

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
  uv pip install -r requirements*.txt >&2
elif [ -f "package.json" ]; then
  log "Node.js project detected"
  npm install >&2
elif [ -f "Cargo.toml" ]; then
  log "Rust project detected"
  cargo build >&2
elif [ -f "go.mod" ]; then
  log "Go project detected"
  go mod download >&2
else
  log "No recognized project file — skipping dependency setup"
fi

# THE critical output line — absolute path to worktree
echo "$WORKTREE_PATH"
