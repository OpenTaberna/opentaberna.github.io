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

required = %w[
  index.html robots.txt llms.txt sitemap.xml CNAME
  assets/css/site.css wiki/taberna_logo.png
]
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
if sitemap && !sitemap.include?("https://#{DOMAIN}/")
  fail!("sitemap.xml: does not contain the canonical site URL")
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

index = read("index.html")
if index
  fail!("index.html: has lost the Philipp Lehmann website link") unless index.include?('href="https://philipptheserver.com"')
  fail!("index.html: has lost the maltonoloco GitHub link") unless index.include?('href="https://github.com/maltonoloco"')

  sections = [
    "What OpenTaberna is",
    "What it is made of",
    "How to start",
    "Licence and intent",
    "Founders",
    "Contact",
  ]
  positions = sections.map { |heading| [heading, index.index(heading)] }
  positions.each { |heading, position| fail!("index.html: has lost the #{heading.inspect} section") if position.nil? }
  present_positions = positions.map(&:last).compact
  fail!("index.html: required sections are out of order") unless present_positions == present_positions.sort

  title = index[%r{<title>(.*?)</title>}m, 1].to_s
  description = index[/<meta name="description" content="([^"]*)"/, 1].to_s
  h1 = index[%r{<h1[^>]*>(.*?)</h1>}m, 1].to_s
  {
    "title" => [title, %w[open-source self-hosted headless shop]],
    "meta description" => [description, %w[open-source self-hosted headless shop]],
    "h1" => [h1, %w[open-source headless shop]],
  }.each do |name, (text, terms)|
    terms.each { |term| fail!("index.html: #{name} has lost the search term #{term.inspect}") unless text.downcase.include?(term) }
  end

  %w[
    https://github.com/OpenTaberna/fastapi
    https://github.com/OpenTaberna/frontend
    https://github.com/OpenTaberna/admin_frontend
    https://github.com/OpenTaberna/wiki
    https://wiki.opentaberna.de
    https://github.com/OpenTaberna/wiki/blob/main/Getting-Started.md
  ].each do |url|
    fail!("index.html: has lost #{url}") unless index.include?(%[href="#{url}"])
  end
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
