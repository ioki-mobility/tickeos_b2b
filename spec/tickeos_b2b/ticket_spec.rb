require 'spec_helper'

RSpec.describe TickeosB2b::Ticket do
  let(:ticket_json) do
    Nori.new.parse(
      <<~XML
        <?xml version="1.0"?>
        <TICKeosProxy apiVersion="1.0" version="2012.12" instanceName="tickeos-test">
          <txPurchaseResponse>
            <ordering server_ordering_serial="2012112900008"/>
            <productData client_order_product_serial="1211035" server_order_product_serial="1211599" price_net="5.7" price_gross="6.1" price_vat="0.4" price_vat_rate="7"/>
          </txPurchaseResponse>
        </TICKeosProxy>
      XML
    )
  end

  let(:errors_json) do
    Nori.new.parse(
      <<~XML
        <?xml version="1.0"?>
        <TICKeosProxy apiVersion="1.0" version="2012.12" instanceName="tickeos-test">
          <txPurchaseResponse>
            <productData price_net="5.7" price_gross="6.1" price_vat="0.4" price_vat_rate="7"/>
            <error code="0301" message="errors while processing purchase request">
              <detail error_message="order with external serial number '123456789' already exists for this client." error_code="0301"/>
            </error>
          </txPurchaseResponse>
        </TICKeosProxy>
      XML
    )
  end

  let(:validation_errors_json) do
    Nori.new.parse(
      <<~XML
        <?xml version="1.0"?>
        <TICKeosProxy apiVersion="1.0" version="2012.12" instanceName="tickeos-test">
          <txPurchaseResponse>
            <productData price_net="5.7" price_gross="6.1" price_vat="0.4" price_vat_rate="7"/>
            <validationError code="0300" message="validation errors while processing purchase request">
              <customerError field_name="street" error_message="nicht ausgef&#xFC;llt" error_code="required"/>
              <error/>
            </validationError>
          </txPurchaseResponse>
        </TICKeosProxy>
      XML
    )
  end

  let(:ticket) { described_class.new(personalisation_data) }
  let(:personalisation_data) do
    {
      first_name:        'Json',
      last_name:         'Statham',
      validation_date:   Time.now,
      sub_ref_id:        'kein Zuschlag',
      location_id:       '123456789',
      product_type_role: 'abo_zones'
    }
  end

  describe '.new' do
    it 'creates a new Ticket object' do
      expect(described_class.new).to be_an_instance_of(TickeosB2b::Ticket)
    end
  end

  describe '.attributes' do
    let(:expected_attributes) do
      {
        state:                       :new,
        product:                     nil,
        product_reference_id:        nil,
        errors:                      nil,
        serial_ordering:             nil,
        transaction_id:              nil,
        sub_ref_id:                  nil,
        validation_date:             nil,
        first_name:                  nil,
        last_name:                   nil,
        location_id:                 nil,
        product_type_role:           nil,
        server_ordering_serial:      nil,
        server_order_product_serial: nil,
        price_net:                   nil,
        price_gross:                 nil,
        price_vat:                   nil,
        price_vat_rate:              nil
      }
    end

    it 'returns the Ticket attributes correctly' do
      expect(described_class.new.attributes).to eq(expected_attributes)
    end
  end

  describe '.load_ticket_data' do
    let(:purchased_ticket) { described_class.load_ticket_data(ticket, purchased_ticket_data) }

    context 'when there are standard errors' do
      let(:purchased_ticket_data) { errors_json }
      let(:errors) do
        {
          error_type:    :standard,
          error_code:    '0301',
          error_message: "order with external serial number '123456789' already exists for this client."
        }
      end

      it 'returns an invalid ticket with standard errors' do
        purchased_ticket
        expect(purchased_ticket.state).to eq(:invalid)
        expect(purchased_ticket.errors).to eq(errors)
        expect(purchased_ticket.server_ordering_serial).to be_nil
        expect(purchased_ticket.server_order_product_serial).to be_nil
        expect(purchased_ticket.price_net).to be_nil
        expect(purchased_ticket.price_gross).to be_nil
        expect(purchased_ticket.price_vat).to be_nil
        expect(purchased_ticket.price_vat_rate).to be_nil
      end
    end

    context 'when there are validation errors' do
      let(:purchased_ticket_data) { validation_errors_json }
      let(:validation_errors) do
        {
          error_type:     :validation_error,
          error_product:  nil,
          error_payment:  nil,
          error_customer: {
            '@field_name'    => 'street',
            '@error_message' => 'nicht ausgefüllt',
            '@error_code'    => 'required'
          },
          error_code:     '0300',
          error_message:  'validation errors while processing purchase request'
        }
      end

      it 'returns an invalid ticket with validation errors' do
        purchased_ticket
        expect(purchased_ticket.state).to eq(:invalid)
        expect(purchased_ticket.errors).to eq(validation_errors)
        expect(purchased_ticket.server_ordering_serial).to be_nil
        expect(purchased_ticket.server_order_product_serial).to be_nil
        expect(purchased_ticket.price_net).to be_nil
        expect(purchased_ticket.price_gross).to be_nil
        expect(purchased_ticket.price_vat).to be_nil
        expect(purchased_ticket.price_vat_rate).to be_nil
      end
    end

    context 'when there are no errors' do
      let(:purchased_ticket_data) { ticket_json }

      it 'extracts the information from load_ticket_data hash correctly' do
        purchased_ticket
        expect(purchased_ticket.state).to eq(:purchased)
        expect(purchased_ticket.errors).to be_nil
        expect(purchased_ticket.server_ordering_serial).to eq('2012112900008')
        expect(purchased_ticket.server_order_product_serial).to eq('1211599')
        expect(purchased_ticket.price_net).to eq(5.7)
        expect(purchased_ticket.price_gross).to eq(6.1)
        expect(purchased_ticket.price_vat).to eq(0.4)
        expect(purchased_ticket.price_vat_rate).to eq(7)
      end
    end
  end
end
