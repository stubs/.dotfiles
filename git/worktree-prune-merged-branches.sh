#!/usr/bin/env bash

set -euo pipefail

main_branch="${1:-main}"

echo "Checking merged branches into $main_branch..."

git fetch -p

git worktree list --porcelain | awk '
  /worktree/ {wt=$2}
  /branch/ {
    br=$2
    sub("refs/heads/", "", br)
    print wt, br
  }
' | while read -r wt br; do

  # Skip main branch
  if [[ "$br" == "$main_branch" ]]; then
    continue
  fi

  # Skip branches that were never pushed to a remote
  if ! git -C "$wt" rev-parse --abbrev-ref --symbolic-full-name "$br@{upstream}" >/dev/null 2>&1 \
     && [[ -z "$(git config --get "branch.$br.merge" || true)" ]]; then
    echo "Skipping: $wt ($br never pushed)"
    continue
  fi

  if git merge-base --is-ancestor "$br" "$main_branch"; then
    if [[ -n "$(git -C "$wt" status --porcelain)" ]]; then
      echo "⚠️  Dirty, skipping: $wt ($br merged but has uncommitted/untracked changes)"
      continue
    fi
    echo "🧹 Removing worktree: $wt (merged: $br)"
    git worktree remove "$wt" || echo "❌ Failed to remove: $wt"
  else
    echo "Keeping: $wt ($br not merged)"
  fi

done
