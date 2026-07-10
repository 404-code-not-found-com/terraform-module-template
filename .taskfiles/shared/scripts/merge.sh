#!/usr/bin/env bash
#
# Create a PR/MR for the current branch, wait for required checks, merge with a
# real merge commit, delete the branch, and update the local checkout.

set -o errexit
set -o nounset
set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "${SCRIPT_DIR}/lib.sh"

github_flow() {
  if gh pr view >/dev/null 2>&1; then
    echo "A pull request already exists for this branch."
  else
    echo "Creating pull request on GitHub..."
    gh pr create --fill-verbose
  fi
  github_merge_current_pr
  echo "Pull request merged. Updating local checkout..."
  git pull --ff-only || echo "Could not fast-forward local branch; pull manually." >&2
  watch_post_merge_ci
}

gitlab_flow() {
  local source_branch target
  source_branch="$(git rev-parse --abbrev-ref HEAD)"
  if glab mr view >/dev/null 2>&1; then
    echo "A merge request already exists for this branch."
  else
    echo "Creating merge request on GitLab..."
    glab mr create --fill --fill-commit-body --remove-source-branch --yes
  fi
  glab_merge_current_mr
  target="$(default_branch)"
  git switch "$target"
  git pull --ff-only || echo "Could not fast-forward ${target}; pull manually." >&2
  git branch --delete "$source_branch" 2>/dev/null || true
  echo "Merged MR and cleaned up ${source_branch}."
}

main() {
  # Let the CLIs resolve the host from the repo's remote instead of matching
  # hostnames ourselves. gh recognizes github.com (and GitHub Enterprise hosts
  # it's authed to); glab recognizes gitlab.com and self-hosted GitLab.
  if gh repo view >/dev/null 2>&1; then
    github_flow
  elif glab repo view >/dev/null 2>&1; then
    gitlab_flow
  else
    echo "No GitHub or GitLab remote detected (is gh/glab authenticated here?)." >&2
    exit 1
  fi
}

main "$@"
