# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TickeosB2b do
  let(:version) { '0.2.0' }

  it 'has the correct version number' do
    expect(TickeosB2b::VERSION).not_to be_nil
    expect(TickeosB2b::VERSION).to eq(version)
  end
end
