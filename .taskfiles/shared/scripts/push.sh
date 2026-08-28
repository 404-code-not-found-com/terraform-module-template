#!/usr/bin/env bash
#
# Backs the `push` task in git.yml. Handles two things the Taskfile YAML
# can't express cleanly:
#
#   1. Branch naming: when on main, derive a <type>/<slug> branch name from
#      the (already Conventional-Commit-validated) MESSAGE, unless BRANCH
#      overrides it.
#   2. git-add safety: refuse to silently sweep up new untracked files;
#      require an explicit opt-in (ALLOW_UNTRACKED=true) or explicit paths
#      (FILES=...).
#
# Env vars (all set by the `push` task, all have safe defaults):
#   MESSAGE           Conventional Commit message.
#   BRANCH            Explicit branch name override; used verbatim if set.
#   CURRENT_DATE      Fallback slug source (shared CURRENT_DATE var).
#   FILES             Paths to stage. Default ".".
#   ALLOW_UNTRACKED   "true" to allow untracked files when FILES is ".".

set -o errexit
set -o nounset
set -o pipefail

MESSAGE="${MESSAGE:-}"
BRANCH="${BRANCH:-}"
CURRENT_DATE="${CURRENT_DATE:-}"
FILES="${FILES:-.}"
ALLOW_UNTRACKED="${ALLOW_UNTRACKED:-false}"

# Sanitize free text into a safe branch-name component: lowercase, collapse
# runs of non-alphanumerics to a single hyphen, strip leading/trailing
# hyphens, cap length, then strip any hyphen left dangling by truncation.
sanitize_slug() {
  printf '%s' "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//' \
    | cut -c1-40 \
    | sed -E 's/-+$//'
}

# Derive "<type>/<slug>" from MESSAGE. MESSAGE is already validated upstream
# by the task's Conventional Commit precondition; the fallback branch below
# is defensive only and should be unreachable in normal use.
branch_from_message() {
  local re='^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\([a-zA-Z0-9_.-]+\))?!?: (.+)$'
  local type desc slug
  if [[ "${MESSAGE}" =~ ${re} ]]; then
    type="${BASH_REMATCH[1]}"
    desc="${BASH_REMATCH[3]}"
  else
    type="chore"
    desc="${MESSAGE}"
  fi

  slug="$(sanitize_slug "${desc}")"
  if [[ -z "${slug}" ]]; then
    # Description sanitized away to nothing (e.g. "chore: ---"); fall back
    # to the timestamp so we never produce an invalid "type/" ref.
    slug="$(sanitize_slug "${CURRENT_DATE}")"
  fi

  printf '%s/%s\n' "${type}" "${slug}"
}

# Append -2, -3, ... until the name is free, locally and on origin. Avoids
# both a confusing raw "branch already exists" error and silently reusing
# an unrelated branch's history.
unique_branch() {
  local base="$1" candidate="$1" n=2
  while git show-ref --verify --quiet "refs/heads/${candidate}" \
     || git ls-remote --exit-code --heads origin "${candidate}" >/dev/null 2>&1; do
    candidate="${base}-${n}"
    n=$((n + 1))
  done
  printf '%s\n' "${candidate}"
}

if [[ "$(git rev-parse --abbrev-ref HEAD)" == "main" ]]; then
  if [[ -n "${BRANCH}" ]]; then
    target_branch="${BRANCH}"
  else
    target_branch="$(unique_branch "$(branch_from_message)")"
  fi
  git switch --create "${target_branch}"
fi

# Only guard the default "stage everything" case. Explicit FILES is already
# a deliberate act, so it bypasses the safety net by design.
if [[ "${FILES}" == "." && "${ALLOW_UNTRACKED}" != "true" ]]; then
  untracked=()
  while IFS= read -r -d '' entry; do
    [[ "${entry:0:2}" == "??" ]] && untracked+=("${entry:3}")
  done < <(git status --porcelain=v1 --untracked-files=all -z)

  if ((${#untracked[@]} > 0)); then
    echo "Refusing to stage: new untracked file(s) would be swept into this commit:" >&2
    printf '  %s\n' "${untracked[@]}" >&2
    echo >&2
    echo "Options:" >&2
    echo "  - task push ALLOW_UNTRACKED=true          # include them" >&2
    echo '  - task push FILES="path/a path/b"          # stage specific paths instead' >&2
    exit 1
  fi
fi

# shellcheck disable=SC2086 # FILES may be a space-separated list of paths
git add ${FILES}
