---
layout: default
lang: en
alt_url: /de/entwickler/
title: For developers
permalink: /developers/
description: >-
  OpenTaberna for developers: a self-hosted, open-source headless shop system built on
  FastAPI, PostgreSQL, Keycloak and Angular. Repositories, stack and documentation.
---
<div class="wrap narrow page" markdown="1">

<p class="eyebrow">For developers</p>

# An open-source headless shop system you can read, run and change.
{: .page-title}

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

OpenTaberna is entirely open source: every repository is licensed under Apache-2.0.
You are free to run it, fork it, maintain it for your own needs or sell it on. The
software stays free. Paid help with setup, hosting and custom storefronts comes from
[vaultops](/#offers), run by one of the founders.


</div>
