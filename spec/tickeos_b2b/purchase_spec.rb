# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TickeosB2b::Purchase do
  subject(:purchase) { described_class }

  let(:request_body) do
    <<~XML
      <?xml version=\"1.0\"?>
      <TICKeosProxy apiVersion=\"\" version=\"\" instanceName=\"\">
        <txPurchaseRequest preCheck=\"0\" go=\"1\">
          <ordering serial_number=\"rid_123\" app=\"mobile\"/>
          <orderCustomer serial_number=\"\" salutation=\"\" first_name=\"Json\" last_name=\"Statham\" email=\"\" birthday=\"\" street=\"\" street_number=\"\" postal_code=\"\" city=\"\" country=\"\">
            <title value=\"\"/>
            <identityCard ref_id=\"p\" name=\"Personalausweis\" value=\"\" number=\"\"/>
          </orderCustomer>
          <optionProduct reference_id=\"test_ticket\" quantity=\"1\" serial_number=\"42\">
            <validationDate timestamp=\"2020-09-02\"/>
            <location id=\"\"/>
            <validationEndDate timestamp=\"\"/>
            <zone value=\"\"/>
            <zone value=\"\"/>
            <personalisation role=\"first_name\" type=\"plain\">
              <value>Json</value>
            </personalisation>
            <personalisation role=\"last_name\" type=\"plain\">
              <value>Statham</value>
            </personalisation>
            <subProductSelections productTypeRole=\"subproduct\">
              <subProductSelection reference_id=\"\" serial_number=\"\" quantity=\"1\">
                <validationEndDate timestamp=\"\"/>
              </subProductSelection>
            </subProductSelections>
          </optionProduct>
          <payment transaction_id=\"123ABC\" payed_amount=\"3.5\" method_detail=\"\"/>
        </txPurchaseRequest>
      </TICKeosProxy>
    XML
  end

  let(:operation) { purchase.request_body(pre_check, go, options) }
  let(:pre_check) { '0' }
  let(:go) { '1' }
  let(:options) do
    {
      serial_ordering:  'rid_123',
      first_name:       'Json',
      last_name:        'Statham',
      ref_id:           'test_ticket',
      quantity:         '1',
      serial_product:   '42',
      date_to_validate: Date.new(2020, 9, 2),
      location_id:      nil,
      sub_re_id:        'AB',
      transaction_id:   '123ABC',
      payed_amount:     '3.5'
    }
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
