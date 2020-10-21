# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TickeosB2b::Api::Purchase do
  subject(:purchase) { described_class }

  let(:request_body) do
    <<~XML
      <?xml version="1.0"?>
      <TICKeosProxy apiVersion="" version="" instanceName="">
        <txPurchaseRequest preCheck="0" go="1">
          <ordering serial_number="ord_123" app="mobile"/>
          <orderCustomer serial_number="" salutation="" first_name="Json" last_name="Statham" email="" birthday="" street="" street_number="" postal_code="" city="" country="">
            <title value=""/>
            <identityCard ref_id="p" name="Personalausweis" value="" number=""/>
          </orderCustomer>
          <optionProduct reference_id="test_ticket" quantity="1" serial_number="42">
            <validationDate timestamp="2020-09-02"/>
            <location id="Master:8123456"/>
            <validationEndDate timestamp=""/>
            <personalisation role="first_name" type="plain">
              <value>Json</value>
            </personalisation>
            <personalisation role="last_name" type="plain">
              <value>Statham</value>
            </personalisation>
            <subProductSelections productTypeRole="abo_zones">
              <subProductSelection reference_id="kein Zuschlag" serial_number="" quantity="1">
                <validationEndDate timestamp=""/>
              </subProductSelection>
            </subProductSelections>
          </optionProduct>
          <payment transaction_id="123ABC" payed_amount="" method_detail=""/>
        </txPurchaseRequest>
      </TICKeosProxy>
    XML
  end

  let(:operation) { purchase.request_body(pre_check, go, ticket) }
  let(:pre_check) { '0' }
  let(:go) { '1' }

  let(:product) do
    TickeosB2b::Product.new(
      name:         'Test Ticket',
      reference_id: 'test_ticket',
      updated_at:   Time.now,
      published:    true,
      id:           '42'
    )
  end

  let(:ticket) do
    TickeosB2b::Ticket.new(
      product:              product,
      product_reference_id: 'test_ticket',
      serial_ordering:      'ord_123',
      transaction_id:       '123ABC',
      sub_ref_id:           'kein Zuschlag',
      validation_date:      Date.new(2020, 9, 2),
      first_name:           'Json',
      last_name:            'Statham',
      location_id:          'Master:8123456',
      product_type_role:    'abo_zones'
    )
  end

  describe '#request_body' do
    it 'returns the correct xml request body' do
      expect(operation).to eq(request_body)
    end
  end

  describe '#request_method' do
    it 'returns the correct request method' do
      expect(purchase.request_method).to eq(:post)
    end
  end
end
