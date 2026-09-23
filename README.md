# OpenTaberna website

The static project website for [OpenTaberna](https://opentaberna.de). It uses
Jekyll, is built and verified by GitHub Actions, and is deployed to GitHub Pages.
The project documentation remains in the
[OpenTaberna wiki](https://wiki.opentaberna.de).

## What the site is for

opentaberna.de is a customer landing page. OpenTaberna is free; vaultops sells
setup on the customer's server, hosting in Germany and custom storefronts. Every
call to action is a pre-filled `mailto:` link, so there is no form, no third party
and no cookie banner. Nothing may load from another origin.

## Pages and where their content lives

| URL | Source | Content |
|---|---|---|
| `/`, `/de/` | `index.md`, `de/index.md` → `_includes/landing.html` | copy in `_data/i18n.yml` (`en`, `de`) |
| `/developers/`, `/de/entwickler/` | `developers/index.md`, `de/entwickler/index.md` | Markdown in the page |
| `/impressum/`, `/datenschutz/` | `impressum/index.md`, `datenschutz/index.md` | German only |

Both landing pages render one template from `_data/i18n.yml`, so their structure
cannot drift; the mail subjects and bodies live there too. Pages that exist in
both languages set `lang` and `alt_url`, which drive the `hreflang` alternates and
the language switch. A content change to one language belongs in the other in the
same change.

The comparison with Shopware and Shopify cites the vendors' own pricing pages.
Re-check those figures before changing the table and update the "as published"
month.

## Product screenshots

`assets/img/*.webp` are screenshots of the real `frontend` and `admin_frontend`
running against the `fastapi` dev stack with the sample catalogue (`seed.py`) and
illustrated product images, taken at 1440×900 with 2× pixel density and
converted with `cwebp -q 78 -resize 1600 0`. `assets/img/og.jpg` is the 1200×630
social preview cropped from the storefront screenshot.

## Checks

`scripts/check_site.rb` fails if any page, its language pairing or footer legal
links go missing; if the landing sections change order or lose their email calls
to action, the wiki link or the comparison sources; if the Impressum or privacy
policy lose their required details; if any page loads a resource from another
origin or a screenshot lacks alt text; if a page links to the not-yet-existing
demo shop; if the home pages lose their search terms (English title, description
and H1; German description and H1); and if the developer pages or `llms.txt` lose
the stack terms listed in `STACK`.

## Local verification

Install Ruby 3.3 and Bundler, then run:

```sh
bundle install
./scripts/verify.sh
```

The command builds `_site`, validates internal links and markup, and runs the
project-specific structural checks described above.

## Publishing

Pushes to `main` run `.github/workflows/deploy.yml`. The workflow verifies the
site before it uploads and deploys the GitHub Pages artifact. Pages must use
**GitHub Actions** as its source, with the custom domain `opentaberna.de` and
**Enforce HTTPS** enabled. After each deploy the workflow checks that
`http://opentaberna.de/` redirects to HTTPS and fails if it does not.

The repository's `CNAME` file is in place. The apex and `www` DNS records can
therefore be added as documented in the project issue; the `wiki` subdomain is
unrelated to this deployment.
