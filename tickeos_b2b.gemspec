# frozen_string_literal: true

require_relative 'lib/tickeos_b2b/version'

Gem::Specification.new do |gem|
  gem.name          = 'tickeos_b2b'
  gem.version       = TickeosB2b::VERSION
  gem.summary       = 'Ruby bindings for the TICKeos B2B API'
  gem.authors       = ['@tom-ioki']
  gem.email         = 'tobias.matz@ioki.com'
  gem.homepage      = 'https://github.com/dbdrive/tickeos_b2b'
  gem.license       = 'MIT'
  gem.required_ruby_version = '>= 3.0'

  gem.files = Dir['lib/**/*']
  gem.require_paths = %w[lib]
  gem.extra_rdoc_files = %w[CHANGELOG.md LICENSE.md README.md Rakefile lib spec]

  gem.add_dependency 'activesupport'
  gem.add_dependency 'faraday'
  gem.add_dependency 'nokogiri'
  gem.add_dependency 'nori'

  gem.metadata = {
    'homepage_uri'          => 'https://github.com/dbdrive/tickeos_b2b',
    'changelog_uri'         => "https://github.com/dbdrive/tickeos_b2b/releases/tag/v#{gem.version}",
    'source_code_uri'       => 'https://github.com/dbdrive/tickeos_b2b',
    'bug_tracker_uri'       => 'https://github.com/dbdrive/tickeos_b2b/issues',
    'rubygems_mfa_required' => 'true'
  }
end
