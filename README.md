# dereksleepfield.com

A small library of not-academic writing by Derek Wakefield.
The not-academic shelf — parables, codas, essays, apps, games.

Sister site to [derekwakefield.com](https://derekwakefield.com) (academic).

## Stack

- [Quarto](https://quarto.org) static-site generator
- GitHub Pages hosting (custom domain via `CNAME`)
- Cloudflare DNS
- Custom **Quiet Library** theme in `themes.css` — parchment + warm ink + sepia,
  layered over Quarto's `cosmo` (light) and `darkly` (dark) bases

## Layout

```
.
├── _quarto.yml           Site config + navbar
├── index.qmd             Landing ("The shelf.")
├── writing.qmd           Listing page
├── presentations.qmd     Listing page
├── apps.qmd              Listing page
├── games.qmd             Listing page
├── posts/                Writing posts (personal · bobology · notes · short-stories)
├── presentations/        Presentation posts (bobology · other)
├── apps/                 App posts
├── games/                Game posts
├── assets/               PDFs, PPTXs, supporting files
├── themes.css            Quiet Library theme
├── CNAME                 dereksleepfield.com
└── *.html                Standalone content pages referenced by post .qmd files
```

## Local preview

```bash
quarto preview
```

## Publishing

GitHub Pages reads from the `main` branch on push. Pages must be enabled in
repo settings with custom domain `dereksleepfield.com`.

```bash
quarto render
git add -A && git commit -m "publish" && git push
```

## Migration note

This site was carved out of [`webs-aight`](https://github.com/DerekSleepfield/webs-aight)
on 2026-05-26 — the academic site stayed there, the creative writing came here.
