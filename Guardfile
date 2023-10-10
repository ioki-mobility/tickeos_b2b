# frozen_string_literal: true

# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :rspec, cmd: "bundle exec #{'bin/spring' if ENV.fetch('USE_SPRING', 'no') == 'yes'} " \
                   'rspec --format=documentation --tag focus' do
  # watch(%r{.*}) { |m| puts "Change detected on #{m.inspect}"; nil }

  watch(%r{^spec/.+_spec\.rb$})

  watch(%r{^lib/(.+)\.rb$}) do |m|
    "spec/#{m[1]}_spec.rb"
  end

  watch('spec/spec_helper.rb') do
    'spec'
  end

  # Factories
  watch(%r{^spec/factories/(.+)\.rb}) { 'spec/models/factories_spec.rb' }
end
