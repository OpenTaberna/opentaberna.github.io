---
layout: default
title: OpenTaberna
permalink: /
description: >-
  OpenTaberna is an open-source, self-hosted headless shop system: build a modern,
  custom web shop and automate e-commerce end to end. A free Shopware alternative.
---

<section class="hero" aria-labelledby="hero-title">
  <div>
    <p class="eyebrow">Open-source e-commerce, self-hosted</p>
    <h1 id="hero-title">The open-source headless shop system you can make your own.</h1>
    <p class="lede">OpenTaberna is a modern, self-hosted web shop platform: headless e-commerce that is open source all the way down and automates the commerce workflow end to end.</p>
  </div>
  <img class="hero-logo" src="/wiki/taberna_logo.png" alt="OpenTaberna logo" width="1024" height="1024">
</section>

## What OpenTaberna is

We started OpenTaberna because Shopware is expensive and incompatible with nearly
everything we needed to connect, so we built an open-source Shopware alternative.
OpenTaberna separates the storefront, administration and backend, then puts automation
at the centre: from catalogue and checkout to stock, payment and fulfilment.

It is a headless shop by design and self-hosted by default. You run it on your own
servers, choose the interfaces, services and deployment around it, and build the
custom web shop your business needs instead of adapting your operation to a closed
product.

## What it is made of

<ul class="projects">
  <li class="project">
    <h3><a href="https://github.com/OpenTaberna/fastapi">fastapi</a></h3>
    <p>The Python backend owns the API, commerce domain, integrations and automated order workflow.</p>
  </li>
  <li class="project">
    <h3><a href="https://github.com/OpenTaberna/frontend">frontend</a></h3>
    <p>The Angular storefront gives customers catalogue, account, cart and checkout experiences.</p>
  </li>
  <li class="project">
    <h3><a href="https://github.com/OpenTaberna/admin_frontend">admin_frontend</a></h3>
    <p>The role-protected back office manages products, inventory, orders and returns.</p>
  </li>
  <li class="project">
    <h3><a href="https://github.com/OpenTaberna/wiki">wiki</a></h3>
    <p>The documentation repository is the single source of truth for setup, architecture and operation.</p>
  </li>
</ul>

## What it runs on

A self-hosted e-commerce stack built from well-known open-source parts, started with
Docker Compose:

- **Backend:** Python and FastAPI, with async SQLAlchemy on PostgreSQL and Redis for background jobs.
- **Storefront and back office:** Angular, talking to the API. It is headless, so you can bring your own frontend.
- **Accounts:** Keycloak single sign-on for customers and staff.
- **Payment and shipping:** Stripe for payments, DHL for shipping.
- **Documents and files:** Paperless-ngx for accounting documents, MinIO as S3-compatible storage.
- **Operations:** Prometheus, Grafana and OpenTelemetry.

## How to start

<div class="callout">
  <p class="callout-kicker">Start with the documentation</p>
  <p>Read the <a href="https://wiki.opentaberna.de">OpenTaberna wiki</a>, then follow the source-controlled <a href="https://github.com/OpenTaberna/wiki/blob/main/Getting-Started.md">Getting Started guide</a>.</p>
  <p>Setup instructions live there, not here, so the wiki remains the one current source of truth.</p>
</div>

## Licence and intent

OpenTaberna is entirely open source. We are not seeking to make money from the project:
you are free to run it, fork it, maintain it for your own needs or sell it on, subject
to the licences in its repositories.

## Founders

<div class="people">
  <article class="person">
    <p class="person-role">Founder</p>
    <h3><a href="https://philipptheserver.com">Philipp Lehmann</a></h3>
    <p>Infrastructure engineer and open-source builder.</p>
    <p class="person-links"><a href="https://github.com/PhilippTheServer">GitHub</a> · <a href="https://orcid.org/0009-0002-3922-2471">ORCID</a></p>
  </article>
  <article class="person">
    <p class="person-role">Founder</p>
    <h3><a href="https://github.com/maltonoloco">Malte Kottmann</a></h3>
    <p>OpenTaberna founder and contributor.</p>
    <p class="person-links"><a href="https://github.com/maltonoloco">GitHub</a></p>
  </article>
</div>

## Contact

Questions, collaboration and project enquiries are welcome at
[root@vaultops.de](mailto:root@vaultops.de).
