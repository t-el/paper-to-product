#!/usr/bin/env bash
# Publish a daily report: copy it into content/reports/, build-check, commit, push to main.
#
# Usage:
#   scripts/publish-report.sh path/to/report.md [YYYY-MM-DD]
#
# Date defaults to today in Africa/Casablanca. Env options:
#   NO_PUSH=1     commit locally but don't push
#   SKIP_BUILD=1  skip the `hugo --minify` check
#   REMOTE=origin BRANCH=main
set -euo pipefail

SRC="${1:?usage: $0 path/to/report.md [YYYY-MM-DD]}"
DATE="${2:-$(TZ=Africa/Casablanca date +%F)}"
REMOTE="${REMOTE:-origin}"
BRANCH="${BRANCH:-main}"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

[[ -f "$SRC" ]] || { echo "error: $SRC not found" >&2; exit 1; }
[[ "$DATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] || { echo "error: bad date '$DATE'" >&2; exit 1; }

# Basic format checks (see docs/report-style.md)
head -n1 "$SRC" | grep -qx -- '---' || { echo "error: missing YAML front matter" >&2; exit 1; }
for key in title date description tags paper_title paper_url arxiv_id authors verdict score; do
  grep -qE "^${key}:" "$SRC" || { echo "error: front matter missing '${key}'" >&2; exit 1; }
done
for h in '## TL;DR' '## The paper in plain words' '## What it actually enables' '## The product' '## Who pays and how' '## Moat check' '## Build stack' '## Risks and kill criteria' '## Scorecard' '## Sources'; do
  grep -qF "$h" "$SRC" || { echo "error: missing section '$h'" >&2; exit 1; }
done
grep -qE '^draft:\s*true' "$SRC" && { echo "error: report is marked draft: true" >&2; exit 1; }
# Never repeat an arXiv id (style guide section 5)
ID="$(grep -E '^arxiv_id:' "$SRC" | head -1 | sed -E 's/^arxiv_id:[[:space:]]*"?([^"]*)"?.*/\1/')"
if [[ -n "$ID" ]] && grep -lF "arxiv_id: \"$ID\"" content/reports/*.md 2>/dev/null | grep -vqx "content/reports/${DATE}.md"; then
  echo "error: arXiv $ID was already covered" >&2; exit 1
fi

DEST="content/reports/${DATE}.md"
if [[ "$(realpath "$SRC")" != "$(realpath -m "$DEST")" ]]; then
  cp "$SRC" "$DEST"
fi

if [[ "${SKIP_BUILD:-0}" != "1" ]]; then
  command -v hugo >/dev/null || { echo "error: hugo not installed (or set SKIP_BUILD=1)" >&2; exit 1; }
  hugo --minify --quiet --destination "$(mktemp -d)" || { echo "error: hugo build failed" >&2; exit 1; }
fi

# The verdicts entry must land in the same commit (style guide section 6)
grep -qF "url: \"/reports/${DATE//-//}/\"" data/verdicts.yaml || { echo "error: data/verdicts.yaml has no entry for /reports/${DATE//-//}/" >&2; exit 1; }
git add "$DEST" data/verdicts.yaml
if git diff --cached --quiet; then
  echo "nothing to commit: $DEST unchanged"; exit 0
fi
git commit -m "report: ${DATE}"

if [[ "${NO_PUSH:-0}" == "1" ]]; then
  echo "committed locally (NO_PUSH=1): $DEST"; exit 0
fi
git remote get-url "$REMOTE" >/dev/null 2>&1 || { echo "error: no git remote '$REMOTE' configured yet" >&2; exit 1; }
git pull --rebase "$REMOTE" "$BRANCH"
git push "$REMOTE" "HEAD:${BRANCH}"
echo "published: $DEST → ${REMOTE}/${BRANCH} (GitHub Actions will deploy)"
