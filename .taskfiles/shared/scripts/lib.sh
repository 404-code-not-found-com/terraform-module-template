#!/usr/bin/env bash
#
# Shared helpers for merge.sh and review.sh.
# This file is sourced, not executed directly.

# Print origin's default branch (falls back to "main" if it can't be resolved).
default_branch() {
  local branch
  branch="$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null)" || branch=""
  branch="${branch#origin/}"
  printf '%s\n' "${branch:-main}"
}

# Wait for the current PR's required checks to finish, then merge with a real
# merge commit and delete the branch. Works whether or not the repo has the
# auto-merge feature enabled, because it blocks locally until checks pass.
#
# gh pr checks exit codes: 0 = all passed, 8 = no checks reported,
# anything else = a check failed or is still pending after the watch ended.
github_merge_current_pr() {
  echo "Waiting for required checks to pass..."
  local rc=0
  gh pr checks --watch --required --fail-fast --interval 10 || rc=$?
  if [[ $rc -eq 8 ]]; then
    echo "No required checks reported; proceeding to merge."
  elif [[ $rc -ne 0 ]]; then
    echo "Required checks did not pass (exit ${rc}). Aborting merge." >&2
    return 1
  fi
  gh pr merge --merge --delete-branch
}

# Wait for the current MR to become mergeable (bounded), then merge and remove
# the source branch. Terminal-bad statuses fail fast instead of looping.
glab_merge_current_mr() {
  shopt -s nocasematch
  local status tries=0 max=60
  while (( tries < max )); do
    status="$(glab mr view --output json | jq -r '.detailed_merge_status')"
    case "$status" in
      mergeable)
        break
        ;;
      conflict|need_rebase|not_open|draft_status|not_approved| \
      discussions_not_resolved|blocked_status|requested_changes)
        echo "MR cannot be merged (${status}). Aborting." >&2
        shopt -u nocasematch
        return 1
        ;;
      *)
        echo "MR not ready (${status}); retrying in 10s..."
        ;;
    esac
    sleep 10
    (( tries++ )) || true
  done
  shopt -u nocasematch
  if (( tries >= max )); then
    echo "Timed out waiting for MR to become mergeable." >&2
    return 1
  fi
  glab mr merge --remove-source-branch --yes
}

# After a merge, watch the CI run triggered by the merge commit at HEAD.
# Filtering by commit SHA avoids grabbing an unrelated (newest) run.
# Best effort: a missing or failed run warns but never aborts the caller.
watch_post_merge_ci() {
  local sha run_id="" tries=0
  sha="$(git rev-parse HEAD)"
  while [[ -z "$run_id" && $tries -lt 6 ]]; do
    run_id="$(gh run list --commit "$sha" --limit 1 --json databaseId \
      --jq '.[0].databaseId // empty')"
    [[ -n "$run_id" ]] && break
    sleep 5
    (( tries++ )) || true
  done
  if [[ -n "$run_id" ]]; then
    echo "Watching CI run ${run_id} for ${sha:0:7}..."
    gh run watch "$run_id" --compact --exit-status >/dev/null 2>&1 \
      || echo "Post-merge CI run ${run_id} did not succeed; check it manually." >&2
  else
    echo "No post-merge CI run found for ${sha:0:7}."
  fi
}
