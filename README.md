# OpenTaberna website

The static project website for [OpenTaberna](https://opentaberna.de). It uses
Jekyll, is built and verified by GitHub Actions, and is deployed to GitHub Pages.
The project documentation remains in the
[OpenTaberna wiki](https://wiki.opentaberna.de).

## Local verification

Install Ruby 3.3 and Bundler, then run:

```sh
bundle install
./scripts/verify.sh
```

The command builds `_site`, validates internal links and markup, and runs the
project-specific structural checks.

## Publishing

Pushes to `main` run `.github/workflows/deploy.yml`. The workflow verifies the
site before it uploads and deploys the GitHub Pages artifact. Pages must use
**GitHub Actions** as its source, with the custom domain `opentaberna.de` and
**Enforce HTTPS** enabled. After each deploy the workflow checks that
`http://opentaberna.de/` redirects to HTTPS and fails if it does not.

The repository's `CNAME` file is in place. The apex and `www` DNS records can
therefore be added as documented in the project issue; the `wiki` subdomain is
unrelated to this deployment.
