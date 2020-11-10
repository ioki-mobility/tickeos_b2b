# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TickeosB2b::Api::Cancel do
  subject(:cancel) { described_class }

  let(:request_body) do
    <<~XML
      <?xml version=\"1.0\"?>
      <TICKeosProxy apiVersion=\"\" version=\"\" instanceName=\"\">
        <txCancelRequest go=\"1\" context=\"merchant\" orderProductSerial=\"42\"/>
      </TICKeosProxy>
    XML
  end

  let(:operation) do
    cancel.request_body(
      server_order_product_serial: server_order_product_serial
    )
  end
  let(:server_order_product_serial) { '42' }

  describe '#request_body' do
    it 'returns the correct xml request body' do
      expect(operation).to eq(request_body)
    end
  end

  describe '#request_method' do
    it 'returns the correct request method' do
      expect(cancel.request_method).to eq(:post)
    end
  end
end
