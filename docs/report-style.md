# Paper → Product in 24h: Report Style Guide

The spec every daily memo follows. Reference example: `content/reports/2026-11-27.md`.

**Concept.** Each day, pick ONE fresh arXiv paper (posted in the last few days) and write the startup it could become: the paper in plain words, what it really enables, a product spec with a 2-week MVP, who pays, a moat check, build stack, risks and kill criteria, and a verdict: **Business**, **Feature** or **Demo**, scored 0–10.

## 1. Files (both in the same commit)

- Report: `content/reports/YYYY-MM-DD.md` (date in **Africa/Casablanca**).
- Verdicts data: append one entry to `data/verdicts.yaml` (see §6).
- UTF-8, LF, no raw HTML. One report per day.
- Commit message: `report: YYYY-MM-DD`. Corrections: `fix: YYYY-MM-DD <what>`.

## 2. Front matter (YAML, exact keys)

```yaml
---
title: "Paper → Product — Nov 27, 2026: DropRead"   # exactly "Paper → Product — Mon D, YYYY: <product name>"
date: 2026-11-27T09:00:00+00:00          # ISO 8601, never in the future
description: "<140–200 chars: the paper, the product, the verdict>"
summary: "<1–2 sentences ≤ 300 chars for list pages>"
paper_title: "What a Drop Reveals: Sim-to-Real Material Estimation for Deformable Objects from Video"
paper_url: "https://arxiv.org/abs/2611.34894"      # always the /abs/ page, no version suffix
arxiv_id: "2611.34894"                             # no "arXiv:" prefix, no version
authors: ["Ziyue Peng", "Yanxi Hu", "..."]         # as listed on arXiv; for > 8 authors list the first 6 then "et al."
verdict: "Feature"                                 # exactly one of: Business | Feature | Demo
score: 4.5                                         # 0–10, half points allowed (§4)
tags: ["Computer Vision", "Physics Simulation", "Robotics"]   # 4–8, Title Case; first tag = the field (§5)
categories: ["Memo"]
ShowToc: true
TocOpen: false
draft: false
---
```

The cover is generated at build time: `arXiv:<arxiv_id>`, the product name (the part of the title after the colon), and `VERDICT: <verdict> · <score>/10 · <date>`. Keep product names short (≤ 30 characters).

## 3. Body: section order (H2 headings, exact text)

1. `## TL;DR`: exactly **3 bullets**: what the paper does; the product; the verdict + score with the one-line reason.
2. `## The paper in plain words`: 3–5 short paragraphs a smart non-specialist can follow: the problem, the key idea, the evidence (headline numbers **as the authors report them**, with links), and the authors' own limitations. Note the code, model and data licenses.
3. `## What it actually enables`: 3–5 bullets on concrete new capabilities (cheaper, faster, possible for the first time), and one bullet on what it does **not** enable yet.
4. `## The product`: a spec with these bold labels: **Name and one-liner**, **User**, **Job-to-be-done** (in the form "When…, I want to…, so I can…"), **Core features** (3–6 bullets), **MVP in 2 weeks** (a day-by-day or week-by-week plan with what ships at the end and how it's demoed).
5. `## Who pays and how`: the buyer and budget line, then a block starting `**Pricing hypothesis (unvalidated):**`. Any market size or price figure must link to a real source; otherwise write "(guess)" right after it. Name existing alternatives that buyers use today.
6. `## Moat check`: a table `Moat | Strength | Why` with rows Data, Workflow lock-in, Distribution, Technical lead, Licensing/IP (Strength: None / Weak / Medium / Strong). Then one sentence: who could copy this fastest.
7. `## Build stack`: bullets: model/inference, data, app/backend, infrastructure and rough unit cost (labelled estimate), and what can be reused from the paper's release.
8. `## Risks and kill criteria`: 3–6 risks (technical, market, legal) and then **Kill criteria**: 2–4 measurable conditions that would stop the project, each with a deadline (for example, "by week 6").
9. `## Scorecard`: a table `Part | Score | Why` with rows Pain, Readiness, Buyer, Moat, Licensing and build risk (each 0–2) and **Total** (0–10); then **Business vs Feature vs Demo**, one short paragraph per option explaining why it is or isn't that; then the line `**Verdict: <Business|Feature|Demo> · <score>/10**`.
10. `## Sources`: numbered list: the arXiv abstract page first, then the code/model/data pages, then any market or competitor sources. Format: `1. Publisher or authors, "Title" (Mon D, YYYY): https://…`.
11. Closing italic line: `*A product thought experiment, not investment advice, and not endorsed by the paper's authors. Spot an error? Email elkarroumytaha@gmail.com.*`

Length: 1,800–2,500 words.

## 4. Verdict scale and scoring

| Verdict | Score | Meaning |
|---|---|---|
| **Business** | 7–10 | Could support a standalone company: clear buyer with budget, repeatable job, room for a moat. |
| **Feature** | 4–6.5 | Valuable, but belongs inside someone else's product or platform. |
| **Demo** | 0–3.5 | Impressive, not reliable, cheap or general enough to sell yet. |

Score = Pain + Readiness + Buyer + Moat + Licensing and build risk, each 0–2 (half points allowed). The verdict must match the score band. If the total lands in a gap (6.5–7, 3.5–4), round toward the verdict the Business vs Feature vs Demo reasoning supports and say so.

## 5. Rules

- **Every claim about the paper links** to its arXiv abstract page (`https://arxiv.org/abs/<id>`) or to the paper's own code, model or project page. Quote numbers exactly as reported, with their conditions (dataset, hardware, sample size).
- **No invented market numbers.** Market sizes, prices, user counts and growth rates need a real source link; otherwise mark them "(guess)". Pricing is always the labelled **hypothesis**.
- **Freshness:** the paper's first version must be posted on arXiv within the **last 7 days** before the report date (prefer the last 3).
- **Never repeat an arXiv ID** (`scripts/publish-report.sh` refuses duplicates). A new version of a covered paper doesn't count as new.
- **Vary domains:** the first tag is the field (for example Computer Vision, NLP, Robotics, Biology, Energy, Finance, HCI, Security, Materials). Never use the same field two days in a row; check yesterday's first tag before picking.
- **Check licenses** (code, weights, data) and state them; flag non-commercial terms as a risk.
- Be fair to the authors: criticise product fit, not the research. No hype words ("revolutionary", "game-changer").

## 6. Verdicts data-file update rule (`data/verdicts.yaml`)

Every report appends **exactly one** entry to the **end** of `entries:` in the **same commit** as the report:

```yaml
  - date: "2026-11-27"            # report date
    arxiv_id: "2611.34894"        # identical to front matter
    product: "DropRead"           # product name from the title
    verdict: "Feature"            # Business | Feature | Demo, identical to front matter
    score: 4.5                    # identical to front matter
    url: "/reports/2026/11/27/"   # report permalink, leading and trailing slash
```

- Never delete or reorder entries. Edit one only to correct a mistake, adding `corrected: "YYYY-MM-DD: <what>"` and a dated note at the end of that report, in a `fix:` commit.
- The `/verdicts/` page (`layouts/verdicts.html`) renders the table and the Business/Feature/Demo counts and average score automatically.
- `scripts/publish-report.sh` refuses to commit if the entry is missing.

## 7. Checklist before committing

- [ ] Paper posted within 7 days; arXiv ID not used before; first tag differs from yesterday's.
- [ ] Title matches `Paper → Product — Mon D, YYYY: <product name>` exactly.
- [ ] Ten H2 headings in exact order; TL;DR has exactly 3 bullets.
- [ ] Every paper claim linked to arXiv/abs or the paper's code; numbers as reported.
- [ ] Market figures sourced or marked "(guess)"; pricing labelled as a hypothesis.
- [ ] Licenses checked and stated.
- [ ] Scorecard parts add up to the score; verdict matches the band.
- [ ] `data/verdicts.yaml` entry appended; both files in one `report: YYYY-MM-DD` commit; `hugo --minify` builds cleanly.
