# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TickeosB2b::Api::Order do
  subject(:order) { described_class }

  let(:request_body) do
    <<~XML
      <?xml version=\"1.0\"?>
      <TICKeosProxy apiVersion=\"\" version=\"\" instanceName=\"\">
        <txOrderRequest orderingSerial=\"42\" orderProductSerial=\"0815\">
          <part>ticket</part>
          <ticketParameter app=\"mobile\" outputFormat=\"png\"/>
        </txOrderRequest>
      </TICKeosProxy>
    XML
  end

  let(:operation) do
    order.request_body(
      server_ordering_serial:      server_ordering_serial,
      server_order_product_serial: server_order_product_serial
    )
  end
  let(:server_ordering_serial) { '42' }
  let(:server_order_product_serial) { '0815' }

  describe '#request_body' do
    it 'returns the correct xml request body' do
      expect(operation).to eq(request_body)
    end
  end

  describe '#request_method' do
    it 'returns the correct request method' do
      expect(order.request_method).to eq(:get)
    end
  end
end
