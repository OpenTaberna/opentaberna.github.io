#!/usr/bin/env ruby
# Structural checks on the built site. Run by scripts/verify.sh and by CI.
# Exits non-zero, listing every failure, if the site stops holding together.

require "json"
require "uri"

SITE = ARGV[0] || "_site"
DOMAIN = "opentaberna.de"
ORCID = "0009-0002-3922-2471"

@failures = []

def fail!(message)
  @failures << message
end

def read(path)
  full = File.join(SITE, path)
  return nil unless File.file?(full)

  File.read(full)
end

def internal_target(reference)
  return nil if reference.nil? || reference.empty? || reference.start_with?("#")
  return nil if reference.match?(%r{\A(?:mailto|tel|data|javascript):}i)

  uri = URI.parse(reference)
  return nil if uri.host && uri.host != DOMAIN

  path = uri.path.to_s
  path = "/" if path.empty?
  path = path.sub(%r{\A/}, "")
  path = "index.html" if path.empty?
  path = File.join(path, "index.html") if path.end_with?("/")
  path
rescue URI::InvalidURIError
  nil
end

PAGES = {
  "index.html" => { url: "/", lang: "en", locale: "en_GB", pair: "/de/" },
  "de/index.html" => { url: "/de/", lang: "de", locale: "de_DE", pair: "/" },
  "developers/index.html" => { url: "/developers/", lang: "en", locale: "en_GB", pair: "/de/entwickler/" },
  "de/entwickler/index.html" => { url: "/de/entwickler/", lang: "de", locale: "de_DE", pair: "/developers/" },
  "impressum/index.html" => { url: "/impressum/", lang: "de", locale: "de_DE" },
  "datenschutz/index.html" => { url: "/datenschutz/", lang: "de", locale: "de_DE" },
}.freeze
LANDING = %w[index.html de/index.html].freeze
DEVELOPERS = %w[developers/index.html de/entwickler/index.html].freeze
CONTACT = "mailto:root@vaultops.de"

required = PAGES.keys + %w[robots.txt llms.txt sitemap.xml CNAME assets/css/site.css wiki/taberna_logo.png]
required.each do |path|
  fail!("#{path}: missing from the built site") unless File.file?(File.join(SITE, path))
end

cname = read("CNAME")
unless [DOMAIN, "#{DOMAIN}\n"].include?(cname)
  fail!("CNAME: is #{cname.inspect}, expected exactly #{DOMAIN.inspect}")
end

robots = read("robots.txt")
if robots
  fail!("robots.txt: has no absolute Sitemap line") unless robots.match?(%r{^Sitemap:\s+https://#{Regexp.escape(DOMAIN)}/sitemap\.xml\s*$}i)
  fail!("robots.txt: blocks the whole site") if robots.match?(%r{^Disallow:\s*/\s*$}i)
end

sitemap = read("sitemap.xml")
if sitemap
  PAGES.each_value do |page|
    fail!("sitemap.xml: does not contain #{page[:url]}") unless sitemap.include?("<loc>https://#{DOMAIN}#{page[:url]}</loc>")
  end
end

PAGES.each do |path, page|
  html = read(path)
  next unless html

  fail!("#{path}: <html> is not lang=\"#{page[:lang]}\"") unless html.include?(%(<html lang="#{page[:lang]}">))
  fail!("#{path}: og:locale is not #{page[:locale]}") unless html.include?(%(<meta property="og:locale" content="#{page[:locale]}">))
  %w[/impressum/ /datenschutz/].each do |legal|
    fail!("#{path}: footer has lost the link to #{legal}") unless html[%r{<footer.*</footer>}m].to_s.include?(%(href="#{legal}"))
  end
  next unless page[:pair]

  en, de = page[:lang] == "en" ? [page[:url], page[:pair]] : [page[:pair], page[:url]]
  { "en" => en, "de" => de, "x-default" => en }.each do |hreflang, url|
    unless html.include?(%(<link rel="alternate" hreflang="#{hreflang}" href="https://#{DOMAIN}#{url}">))
      fail!("#{path}: has lost the hreflang=#{hreflang} alternate")
    end
  end
  fail!("#{path}: has lost the language switch to #{page[:pair]}") unless html.match?(/<a class="[^"]*\blang-switch\b[^"]*"[^>]*href="#{Regexp.escape(page[:pair])}"/)
end

STACK = [
  "FastAPI", "PostgreSQL", "Redis", "Keycloak", "Angular", "Stripe", "DHL",
  "Paperless-ngx", "MinIO", "Prometheus", "Grafana", "OpenTelemetry", "Docker Compose",
].freeze
{ "developers/index.html" => "What it runs on", "de/entwickler/index.html" => "Worauf es läuft", "llms.txt" => "## Stack" }.each do |path, heading|
  text = read(path)
  next unless text

  fail!("#{path}: has lost the #{heading.inspect} section") unless text.include?(heading)
  STACK.each { |term| fail!("#{path}: stack section has lost #{term.inspect}") unless text.include?(term) }
end

DEVELOPERS.each do |path|
  html = read(path)
  next unless html

  %w[
    https://github.com/OpenTaberna/fastapi
    https://github.com/OpenTaberna/frontend
    https://github.com/OpenTaberna/admin_frontend
    https://github.com/OpenTaberna/wiki
    https://wiki.opentaberna.de
    https://github.com/OpenTaberna/wiki/blob/main/Getting-Started.md
  ].each { |url| fail!("#{path}: has lost #{url}") unless html.include?(%[href="#{url}"]) }
end

SEARCH_TERMS = {
  "index.html" => { "title" => %w[open-source self-hosted headless shop], "meta description" => %w[open-source self-hosted headless shop], "h1" => %w[open-source shop] },
  "de/index.html" => { "meta description" => ["open-source", "selbst gehostet", "webshop", "shopware"], "h1" => %w[open-source shop] },
}.freeze
SEARCH_TERMS.each do |path, fields|
  html = read(path)
  next unless html

  texts = {
    "title" => html[%r{<title>(.*?)</title>}m, 1],
    "meta description" => html[/<meta name="description" content="([^"]*)"/, 1],
    "h1" => html[%r{<h1[^>]*>(.*?)</h1>}m, 1],
  }
  fields.each do |field, terms|
    terms.each { |term| fail!("#{path}: #{field} has lost the search term #{term.inspect}") unless texts[field].to_s.downcase.include?(term) }
  end
end

html_files = Dir.glob(File.join(SITE, "**", "*.html")).sort
fail!("no HTML pages were built") if html_files.empty?

organization = nil
html_files.each do |path|
  relative = path.delete_prefix("#{SITE}/")
  html = File.read(path)
  block = html[%r{<script type="application/ld\+json">(.*?)</script>}m, 1]

  if block.nil?
    fail!("#{relative}: no JSON-LD block in the page")
    next
  end

  begin
    data = JSON.parse(block)
    organization ||= data
    fail!("#{relative}: JSON-LD @type is not Organization") unless data["@type"] == "Organization"
    fail!("#{relative}: JSON-LD has lost ORCID #{ORCID}") unless block.include?(ORCID)
  rescue JSON::ParserError => e
    fail!("#{relative}: JSON-LD is not valid JSON — #{e.message.lines.first.strip}")
  end
end

if organization
  expected = {
    "@id" => "https://#{DOMAIN}/#organization",
    "name" => "OpenTaberna",
    "url" => "https://#{DOMAIN}",
    "logo" => "https://#{DOMAIN}/wiki/taberna_logo.png",
    "email" => "mailto:root@vaultops.de",
  }
  expected.each do |key, value|
    fail!("JSON-LD #{key} is #{organization[key].inspect}, expected #{value.inspect}") unless organization[key] == value
  end

  same_as = Array(organization["sameAs"])
  %w[https://github.com/OpenTaberna https://wiki.opentaberna.de].each do |url|
    fail!("JSON-LD sameAs has lost #{url}") unless same_as.include?(url)
  end

  founders = Array(organization["founder"])
  philipp = founders.find { |founder| founder["@id"] == "https://philipptheserver.com/#person" }
  malte = founders.find { |founder| founder["name"] == "Malte Kottmann" }
  fail!("JSON-LD has lost Philipp Lehmann's Person node") unless philipp
  fail!("JSON-LD has lost Malte Kottmann's Person node") unless malte

  if philipp
    fail!("JSON-LD Philipp URL is wrong") unless philipp["url"] == "https://philipptheserver.com"
    fail!("JSON-LD Philipp GitHub profile is missing") unless Array(philipp["sameAs"]).include?("https://github.com/PhilippTheServer")
    identifier = philipp["identifier"]
    unless identifier.is_a?(Hash) &&
           identifier["@type"] == "PropertyValue" &&
           identifier["propertyID"] == "ORCID" &&
           identifier["value"] == "https://orcid.org/#{ORCID}" &&
           identifier["url"] == "https://orcid.org/#{ORCID}"
      fail!("JSON-LD Philipp identifier does not carry the complete ORCID PropertyValue")
    end
  end

  if malte
    fail!("JSON-LD Malte Kottmann alternate name is missing") unless malte["alternateName"] == "maltonoloco"
    unless Array(malte["sameAs"]).include?("https://github.com/maltonoloco")
      fail!("JSON-LD Malte Kottmann GitHub profile is missing")
    end
  end
end

SECTIONS = %w[hero trust features offers custom-frontend compare faq get-started founders].freeze
LANDING.each do |path|
  html = read(path)
  next unless html

  positions = SECTIONS.map { |id| [id, html.index(%(id="#{id}"))] }
  positions.each { |id, position| fail!("#{path}: has lost the ##{id} section") if position.nil? }
  present = positions.map(&:last).compact
  fail!("#{path}: landing sections are out of order") unless present == present.sort

  subjects = html.scan(/href="#{Regexp.escape(CONTACT)}\?subject=([^"&]+)/).flatten.uniq
  fail!("#{path}: needs pre-filled emails for setup, hosting, custom frontend and a general enquiry, found #{subjects.length}") if subjects.length < 4

  section = ->(id) { html[%r{id="#{id}".*?</section>}m].to_s }
  fail!("#{path}: hero has lost its email call to action") unless section.call("hero").include?(%(href="#{CONTACT}?subject=))
  fail!("#{path}: closing call to action has lost its email link") unless section.call("get-started").include?(%(href="#{CONTACT}?subject=))
  offers = section.call("offers")
  fail!("#{path}: offers need two quote requests") if offers.scan(%(href="#{CONTACT}?subject=)).length < 2
  fail!("#{path}: do-it-yourself offer has lost the wiki link") unless offers.include?('href="https://wiki.opentaberna.de"')
  fail!("#{path}: custom-frontend section has lost its quote request") unless section.call("custom-frontend").include?(%(href="#{CONTACT}?subject=))
  compare = section.call("compare")
  %w[https://www.shopware.com https://www.shopify.com].each do |source|
    fail!("#{path}: comparison has lost its source #{source}") unless compare.include?(%(href="#{source}))
  end
  fail!("#{path}: has lost the Philipp Lehmann website link") unless html.include?('href="https://philipptheserver.com"')
  fail!("#{path}: has lost the maltonoloco GitHub link") unless html.include?('href="https://github.com/maltonoloco"')
end

impressum = read("impressum/index.html")
if impressum
  ["§ 5 DDG", "§ 18 Abs. 2 MStV", "Philipp Lehmann", "Semperstraße 115", "44801 Bochum", "DE454384537", "root@vaultops.de"].each do |fact|
    fail!("impressum: has lost #{fact.inspect}") unless impressum.include?(fact)
  end
end

privacy = read("datenschutz/index.html")
if privacy
  ["GitHub", "Data Privacy Framework", "Philipp Lehmann", "root@vaultops.de"].each do |fact|
    fail!("datenschutz: has lost #{fact.inspect}") unless privacy.include?(fact)
  end
end

# The site promises visitors that nothing loads from a third party, which is why it
# needs no consent banner. Any external script, stylesheet, font or image breaks that.
css = read("assets/css/site.css").to_s
fail!("site.css: loads something from another origin") if css.match?(%r{url\(\s*["']?(?:https?:)?//|@import}i)
html_files.each do |path|
  relative = path.delete_prefix("#{SITE}/")
  html = File.read(path)
  fail!("#{relative}: loads a resource from another origin") if html.match?(%r{<(?:script|img|iframe|source|video|audio)\b[^>]*\bsrc="(?:https?:)?//}i) ||
                                                                  html.match?(%r{<link\b(?=[^>]*\brel="(?:stylesheet|preload|icon|modulepreload)")[^>]*\bhref="(?:https?:)?//}i)
  html.scan(/<img\b[^>]*>/).each do |tag|
    src = tag[/\bsrc="([^"]*)"/, 1]
    next unless src&.start_with?("/assets/img/")

    fail!("#{relative}: #{src} has no alt text") if tag[/\balt="([^"]*)"/, 1].to_s.strip.empty?
  end
  fail!("#{relative}: links to the demo shop, which does not exist yet") if html.include?("demo.opentaberna")
end

# Resolve every local href and src against the build. html-proofer performs a second,
# markup-aware pass; this check keeps the core 404 guarantee in this script as well.
html_files.each do |path|
  relative = path.delete_prefix("#{SITE}/")
  html = File.read(path)
  html.scan(/\b(?:href|src)="([^"]+)"/).flatten.uniq.each do |reference|
    target = internal_target(reference)
    next if target.nil?

    full = File.join(SITE, target)
    fail!("#{relative}: internal link #{reference.inspect} resolves to missing #{target}") unless File.file?(full)
  end
end

if @failures.empty?
  puts "check_site.rb: all checks passed"
  exit 0
end

warn "check_site.rb: #{@failures.length} failure(s)"
@failures.each { |failure| warn "  ✗ #{failure}" }
exit 1
