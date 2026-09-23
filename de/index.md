---
layout: default
lang: de
title: Open-Source-Shopsystem, headless und selbst gehostet
permalink: /de/
description: >-
  OpenTaberna ist ein Open-Source-Shopsystem, headless und selbst gehostet: Baue
  deinen eigenen modernen Webshop und automatisiere dein E-Commerce von Anfang bis
  Ende. Eine freie Shopware-Alternative.
---

<section class="hero" aria-labelledby="hero-title">
  <div>
    <p class="eyebrow">Open-Source-E-Commerce, selbst gehostet</p>
    <h1 id="hero-title">Das Open-Source-Shopsystem, das wirklich dir gehört.</h1>
    <p class="lede">OpenTaberna ist eine moderne, selbst gehostete Webshop-Plattform: Headless-E-Commerce, durchgehend Open Source, das den Ablauf im Onlinehandel von Anfang bis Ende automatisiert.</p>
  </div>
  <img class="hero-logo" src="/wiki/taberna_logo.png" alt="OpenTaberna-Logo" width="1024" height="1024">
</section>

## Was OpenTaberna ist

Wir haben OpenTaberna gestartet, weil Shopware teuer ist und sich mit kaum etwas
verbinden ließ, das wir anbinden mussten. Also haben wir eine Open-Source-Alternative
zu Shopware gebaut. OpenTaberna trennt Storefront, Verwaltung und Backend und stellt
die Automatisierung in den Mittelpunkt: vom Katalog über Checkout und Lagerbestand bis
zu Zahlung und Versand.

Es ist ein Headless-Shop von Grund auf und standardmäßig selbst gehostet. Du betreibst
ihn auf deinen eigenen Servern, wählst Schnittstellen, Dienste und Deployment selbst
und baust den individuellen Webshop, den dein Geschäft braucht, statt deinen Betrieb
an ein geschlossenes Produkt anzupassen.

## Woraus es besteht

<ul class="projects">
  <li class="project">
    <h3><a href="https://github.com/OpenTaberna/fastapi">fastapi</a></h3>
    <p>Das Python-Backend verantwortet API, Commerce-Domäne, Integrationen und den automatisierten Bestellablauf.</p>
  </li>
  <li class="project">
    <h3><a href="https://github.com/OpenTaberna/frontend">frontend</a></h3>
    <p>Die Angular-Storefront bietet Kundinnen und Kunden Katalog, Konto, Warenkorb und Checkout.</p>
  </li>
  <li class="project">
    <h3><a href="https://github.com/OpenTaberna/admin_frontend">admin_frontend</a></h3>
    <p>Das rollengeschützte Backoffice verwaltet Produkte, Lagerbestand, Bestellungen und Retouren.</p>
  </li>
  <li class="project">
    <h3><a href="https://github.com/OpenTaberna/wiki">wiki</a></h3>
    <p>Das Dokumentations-Repository ist die einzige verbindliche Quelle für Einrichtung, Architektur und Betrieb.</p>
  </li>
</ul>

## Worauf es läuft

Ein selbst gehosteter E-Commerce-Stack aus bewährten Open-Source-Bausteinen, gestartet
mit Docker Compose:

- **Backend:** Python und FastAPI, mit asynchronem SQLAlchemy auf PostgreSQL und Redis für Hintergrundjobs.
- **Storefront und Backoffice:** Angular, angebunden über die API. Es ist headless, du kannst also dein eigenes Frontend mitbringen.
- **Konten:** Keycloak-Single-Sign-on für Kundschaft und Team.
- **Zahlung und Versand:** Stripe für Zahlungen, DHL für den Versand.
- **Dokumente und Dateien:** Paperless-ngx für Buchhaltungsbelege, MinIO als S3-kompatibler Speicher.
- **Betrieb:** Prometheus, Grafana und OpenTelemetry.

## So fängst du an

<div class="callout">
  <p class="callout-kicker">Beginne mit der Dokumentation</p>
  <p>Lies das <a href="https://wiki.opentaberna.de">OpenTaberna-Wiki</a> und folge dann dem versionierten <a href="https://github.com/OpenTaberna/wiki/blob/main/Getting-Started.md">Getting-Started-Guide</a> (auf Englisch).</p>
  <p>Die Einrichtungsanleitung steht dort und nicht hier, damit das Wiki die eine aktuelle Quelle bleibt.</p>
</div>

## Lizenz und Absicht

OpenTaberna ist vollständig Open Source. Wir wollen mit dem Projekt kein Geld verdienen:
Du darfst es betreiben, forken, für deine eigenen Zwecke pflegen oder weiterverkaufen,
im Rahmen der Lizenzen in den jeweiligen Repositories.

## Gründer

<div class="people">
  <article class="person">
    <p class="person-role">Gründer</p>
    <h3><a href="https://philipptheserver.com">Philipp Lehmann</a></h3>
    <p>Infrastruktur-Engineer und Open-Source-Entwickler.</p>
    <p class="person-links"><a href="https://github.com/PhilippTheServer">GitHub</a> · <a href="https://orcid.org/0009-0002-3922-2471">ORCID</a></p>
  </article>
  <article class="person">
    <p class="person-role">Gründer</p>
    <h3><a href="https://github.com/maltonoloco">Malte Kottmann</a></h3>
    <p>Gründer von und Mitwirkender an OpenTaberna.</p>
    <p class="person-links"><a href="https://github.com/maltonoloco">GitHub</a></p>
  </article>
</div>

## Kontakt

Fragen, Zusammenarbeit und Anfragen zum Projekt gern an
[root@vaultops.de](mailto:root@vaultops.de).
