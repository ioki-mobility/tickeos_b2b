# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TickeosB2b::Api::ProductData do
  subject(:product_data) { described_class }

  let(:request_body) do
    <<~XML
      <?xml version=\"1.0\"?>
      <TICKeosProxy apiVersion=\"\" version=\"\" instanceName=\"\">
        <txProductDataRequest productReferenceId=\"test_ticket\" timeIntervalOptionType=\"type\"/>
      </TICKeosProxy>
    XML
  end

  let(:operation) do
    product_data.request_body(
      reference_id: reference_id
    )
  end
  let(:reference_id) { 'test_ticket' }

  describe '#request_body' do
    it 'returns the correct xml request body' do
      expect(operation).to eq(request_body)
    end
  end

  describe '#request_method' do
    it 'returns the correct request method' do
      expect(product_data.request_method).to eq(:get)
    end
  end
end
