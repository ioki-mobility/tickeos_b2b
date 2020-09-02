# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TickeosB2b::ProductList do
  subject(:product_list) { described_class }

  let(:request_body) do
    <<~XML
      <?xml version=\"1.0\"?>
      <TICKeosProxy apiVersion=\"\" version=\"\" instanceName=\"\">
        <txProductRequest method=\"product_list\"/>
      </TICKeosProxy>
    XML
  end

  describe '#request_body' do
    it 'returns the correct xml request body' do
      expect(product_list.request_body).to eq(request_body)
    end
  end

  describe '#request_method' do
    it 'returns the correct request method' do
      expect(product_list.request_method).to eq(:get)
    end
  end
end
