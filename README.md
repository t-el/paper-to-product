# Paper → Product in 24h

Every day, ONE fresh arXiv paper (posted in the last few days) turned into the startup it could become: the paper in plain words, what it enables, a product spec with a 2-week MVP, who pays (pricing as a labelled hypothesis), moat check, build stack, risks and kill criteria, and a verdict: **Business**, **Feature** or **Demo**, scored 0–10. Pipeline: **daily memo + verdicts entry → Hugo → GitHub Actions → GitHub Pages**.

Live: `https://t-el.github.io/paper-to-product/`

Every day a new memo lands in `content/reports/YYYY-MM-DD.md` on `main`, together with its appended entry in `data/verdicts.yaml`, in one commit with message `report: YYYY-MM-DD`. That push triggers `.github/workflows/deploy.yml`, which builds with Hugo and deploys to GitHub Pages.

## What's in the repo

| Path | What it does |
|---|---|
| `hugo.toml` | Site config: name, SEO, menus, homepage concept note, monetization settings (empty = hidden on the public site). |
| `docs/report-style.md` | **The memo spec**: title format, front matter, exact section order, scoring, sourcing rules, verdicts update rule, checklist. |
| `content/reports/` | Daily memos. `2026-11-27.md` (DropRead, from arXiv:2611.34894) is the reference sample. Permalinks: `/reports/YYYY/MM/DD/`. |
| `data/verdicts.yaml` | One entry per memo (append-only): date, arxiv_id, product, verdict, score, url. Rendered by `layouts/verdicts.html` at `/verdicts/` (`content/verdicts.md`). |
| `content/about/`, `content/advertise.md` | About page (rules, scoring) and Advertise page (mailto `elkarroumytaha@gmail.com`). |
| `scripts/publish-report.sh` | Validates a memo (front matter, required sections, no repeated arXiv ID, matching verdicts entry), build-checks, commits both files and pushes. |
| `layouts/_partials/get_cover.html`, `get_cover_base.html`, `cover.html`, `templates/` | Auto-generated covers (arXiv ID, product name, verdict line) and Open Graph / Twitter share tags. |
| `layouts/_partials/extend_head.html`, `extend_post_content.html` | Money blocks (AdSense, newsletter, sponsor, affiliates), rendered only when configured. |
| `layouts/_partials/social_icons.html`, `footer.html` | Subpath-safe RSS icon; footer without personal links. |
| `assets/css/extended/theme.css` | Lab-notebook / VC-memo look: off-white graph paper, ink blue, red-pencil accents; Fraunces + Inter + DM Mono. |
| `assets/images/cover-base.png.b64` | 1200×630 notebook-page cover base, stored base64 and decoded at build time. |
| `assets/fonts/*.ttf.b64` | Fraunces SemiBold and DM Mono Medium (SIL OFL, see `OFL.txt`), Latin subset, base64, decoded at build to paint the cover. These fonts have no "→" glyph, so the cover paints only the product name after the title's colon. |
| `.github/workflows/deploy.yml` | Build and deploy to Pages on every push to `main`. PaperMod is checked out pinned to commit `118119693d8b5ac211b939775678310973bcb232` (no submodule; `themes/` is gitignored). |

Why base64 assets: the repo is managed through the GitHub API (text files only), so binary images and fonts are stored as `.b64` and decoded with `resources.FromString … encoding.Base64Decode` during the build.

Built in: RSS (`/paper-to-product/index.xml`, plus `/reports/index.xml` and per-tag feeds), `sitemap.xml`, `robots.txt`, tags, archive, search, reading time, share buttons.

## Setup

1. Repo: `t-el/paper-to-product` (public).
2. **Settings → Pages → Build and deployment → Source: GitHub Actions.**
3. Actions → "Deploy Hugo site to GitHub Pages" → re-run (or push any commit). `baseURL` is injected by `actions/configure-pages`.

Daily writer: a scheduled routine picks one arXiv paper from the last few days (new arXiv ID, different field from yesterday), writes the memo per `docs/report-style.md`, appends `data/verdicts.yaml`, and commits both in one commit with message `report: YYYY-MM-DD`. Locally:

```bash
bash scripts/publish-report.sh /path/to/draft.md       # date defaults to today (Africa/Casablanca)
NO_PUSH=1 bash scripts/publish-report.sh draft.md      # commit only
```

### Local development

```bash
git clone https://github.com/adityatelange/hugo-PaperMod themes/PaperMod
(cd themes/PaperMod && git checkout 118119693d8b5ac211b939775678310973bcb232)
hugo server -D
```

## Monetization notes

Settings live in `[params.monetization]` in `hugo.toml`; a block renders only when its fields are filled in.

1. **Newsletter**: set `newsletterAction` and optionally `newsletterCTA`.
2. **Sponsors**: set `sponsorText` + `sponsorURL`. Never let a sponsor pick papers or verdicts. `/advertise/` is always public.
3. **Affiliates**: `[[params.monetization.affiliates]]` entries (`name`, `url`, `blurb`), rendered with `rel="sponsored"`.
4. **AdSense**: after ~20–30 quality posts, set `adsenseClient` and `adsenseSlotInArticle`.

## Content policy

Every claim about a paper links to arXiv or the paper's code; no invented market numbers (sourced or marked "(guess)"); pricing is always a labelled hypothesis; product ideas, not investment advice.
