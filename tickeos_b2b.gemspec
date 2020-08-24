# frozen_string_literal: true

lib = 'tickeos_b2b'
lib_file = File.expand_path("../lib/#{lib}.rb", __FILE__)
File.read(lib_file) =~ /\bVERSION\s*=\s*["'](.+?)["']/
version = Regexp.last_match(1)

Gem::Specification.new do |spec|
  spec.name          = lib
  spec.version       = version

  spec.summary       = 'Ruby bindings for the TICKeos B2B API'

  spec.authors       = ['@tom-ioki']
  spec.email         = 'tobias.matz@ioki.com'
  spec.homepage      = 'https://github.com/dbdrive/tickeos_b2b'
  spec.license       = ['MIT']

  spec.required_ruby_version = '>= 2.6'

  spec.add_dependency 'faraday'
  spec.add_dependency 'nokogiri'

  files = %w[CHANGELOG.md LICENSE.md README.md Rakefile lib spec]
  spec.files = `git ls-files -z #{files.join(' ')}`.split("\0")
  spec.require_paths = ["lib"]
  spec.metadata = {
    'homepage_uri'    => 'https://github.com/dbdrive/tickeos_b2b',
    'changelog_uri'   => "https://github.com/dbdrive/tickeos_b2b/releases/tag/v#{spec.version}",
    'source_code_uri' => 'https://github.com/dbdrive/tickeos_b2b',
    'bug_tracker_uri' => 'https://github.com/dbdrive/tickeos_b2b/issues'
  }
end
