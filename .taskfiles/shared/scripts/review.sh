#!/usr/bin/env bash
#
# Show a GitHub PR (metadata, checks, diff), then optionally approve and merge.

set -o errexit
set -o nounset
set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "${SCRIPT_DIR}/lib.sh"

pr="${1:-}"
if [[ -z "$pr" ]]; then
  echo "Usage: $0 <pull-request-number>" >&2
  exit 1
fi

printf 'Reviewing PR %s\n\n' "$pr"
gh pr view "$pr"
printf '\n--- Checks ---\n'
gh pr checks "$pr" || true # exit 8 = no checks; informational only
printf '\n--- Diff ---\n'
gh pr diff "$pr"

if [[ ! -t 0 ]]; then
  echo "Not an interactive terminal; refusing to auto-approve." >&2
  exit 1
fi

printf '\nApprove and merge PR %s? (y/n) ' "$pr"
while true; do
  read -r -n 1 key || { echo; exit 1; }
  case "$key" in
    y | Y)
      printf '\nApproving PR %s...\n' "$pr"
      gh pr review "$pr" --approve --body "LGTM"
      gh pr merge "$pr" --merge --delete-branch
      git pull --ff-only || echo "Could not fast-forward local branch; pull manually." >&2
      watch_post_merge_ci
      echo "PR ${pr} merged."
      exit 0
      ;;
    n | N)
      printf '\nNot approving PR %s.\n' "$pr"
      exit 0
      ;;
    *)
      printf '\nPlease press y or n. '
      ;;
  esac
done
