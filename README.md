# OpenTaberna website

The static project website for [OpenTaberna](https://opentaberna.de). It uses
Jekyll, is built and verified by GitHub Actions, and is deployed to GitHub Pages.
The project documentation remains in the
[OpenTaberna wiki](https://wiki.opentaberna.de).

## Languages

`index.md` is the English page at `/`, `de/index.md` the German page at `/de/`.
Both carry `hreflang` alternates and a language switch; the layout picks its few
interface strings from the page's `lang`. A content change to one page belongs in
the other in the same change. `check_site.rb` fails if the German page, its
alternates or its search terms go missing.

## Local verification

Install Ruby 3.3 and Bundler, then run:

```sh
bundle install
./scripts/verify.sh
```

The command builds `_site`, validates internal links and markup, and runs the
project-specific structural checks. Those checks include the search terms the
home page must keep in its title, meta description and H1 (open-source,
self-hosted, headless, shop), so a copy edit cannot silently drop them.

## Publishing

Pushes to `main` run `.github/workflows/deploy.yml`. The workflow verifies the
site before it uploads and deploys the GitHub Pages artifact. Pages must use
**GitHub Actions** as its source, with the custom domain `opentaberna.de` and
**Enforce HTTPS** enabled.

The repository's `CNAME` file is in place. The apex and `www` DNS records can
therefore be added as documented in the project issue; the `wiki` subdomain is
unrelated to this deployment.
