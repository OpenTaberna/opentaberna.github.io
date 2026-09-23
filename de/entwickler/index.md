---
layout: default
lang: de
alt_url: /developers/
title: Für Entwickler
permalink: /de/entwickler/
description: >-
  OpenTaberna für Entwickler: ein selbst gehostetes Open-Source-Headless-Shopsystem
  auf Basis von FastAPI, PostgreSQL, Keycloak und Angular. Repositories, Stack und Doku.
---
<div class="wrap narrow page" markdown="1">

<p class="eyebrow">Für Entwickler</p>

# Ein Open-Source-Headless-Shopsystem, das du lesen, betreiben und ändern kannst.
{: .page-title}

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

OpenTaberna ist vollständig Open Source: Jedes Repository steht unter Apache-2.0.
Du darfst es betreiben, forken, für deine eigenen Zwecke pflegen oder weiterverkaufen.
Die Software bleibt kostenlos. Bezahlte Hilfe bei Einrichtung, Hosting und individuellen
Storefronts gibt es von [vaultops](/de/#offers), betrieben von einem der Gründer.


</div>
