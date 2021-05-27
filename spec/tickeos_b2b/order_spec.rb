require 'spec_helper'

RSpec.describe TickeosB2b::Order do
  let(:order_json) do
    Nori.new.parse(
      <<~XML
        <?xml version="1.0"?>
        <TICKeosProxy apiVersion="1.0" version="2013.09" instanceName="tickeos">
          <txOrderResponse>
            <part>ticket</part>
            <renderedTicket>{...base64...}</renderedTicket>
            <ticketData>
              <ticket_id>1211599</ticket_id>
              <ticket_type>Fahrkarte</ticket_type>
              <status></status>
              <product_name>EinzelTagesTicket</product_name>
              <tariff_zone>10/20</tariff_zone>
              <passenger_first_name>fn</passenger_first_name>
              <passenger_last_name>ln</passenger_last_name>
              <passenger_birthday>11.08.1966</passenger_birthday>
              <passenger_salutation>1</passenger_salutation>
              <verifying_document_name>Lichtbildausweis</verifying_document_name>
              <verifying_document_short>L</verifying_document_short>
              <verifying_document_number></verifying_document_number>
              <info_text>G&#xFC;ltig am 29.11.2012 00:00</info_text>
              <valid_from>29.11.2012 16:40</valid_from>
              <valid_till>29.11.2012 23:59</valid_till>
              <created_at>29.11.2012 16:40:12</created_at>
              <valid_datetime_string>G&#xFC;ltig am 29.11.2012 00:00</valid_datetime_string>
              <couch_class></couch_class>
              <from_name></from_name>
              <to_name></to_name>
              <via_name></via_name>
              <passenger_type_1_name>Person(en)</passenger_type_1_name>
              <passenger_type_1_number>1</passenger_type_1_number>
              <passenger_type_2_name></passenger_type_2_name>
              <passenger_type_2_number></passenger_type_2_number>
              <price>6.1</price>
              <vat_rate>7,0</vat_rate>
              <currency>EUR</currency>
              <payment_method>TickeosClient</payment_method>
              <vdv_pv_id></vdv_pv_id>
              <vdv_produkt_nummer></vdv_produkt_nummer>
              <vdv_berechtigung_nummer></vdv_berechtigung_nummer>
              <vdv_fahrgast_typ>0</vdv_fahrgast_typ>
              <vdv_service_klasse></vdv_service_klasse>
              <vdv_mitnahme_1_typ>0</vdv_mitnahme_1_typ>
              <vdv_mitnahme_1_anzahl>0</vdv_mitnahme_1_anzahl>
              <vdv_mitnahme_2_typ>0</vdv_mitnahme_2_typ>
              <vdv_mitnahme_2_anzahl>0</vdv_mitnahme_2_anzahl>
              <vdv_bezahl_art>6</vdv_bezahl_art>
            </ticketData>
            <aztecContent>{...base64...}</aztecContent>
          </txOrderResponse>
        </TICKeosProxy>
      XML
    )
  end

  describe '.new' do
    it 'creates a new Order object' do
      expect(described_class.new).to be_an_instance_of(TickeosB2b::Order)
    end
  end

  describe '.attributes' do
    let(:expected_attributes) do
      {
        ticket_id:       nil,
        state:           nil,
        rendered_ticket: nil,
        ticket_data:     nil,
        aztec_content:   nil,
        ordering:        nil
      }
    end

    it 'returns the Order attributes correctly' do
      expect(described_class.new.attributes).to eq(expected_attributes)
    end
  end

  describe '.from_json' do
    let(:order) { described_class.from_json(response: order_json) }
    let(:expected_order_response) { order_json }
    let(:ticket_id) { expected_order_response['TICKeosProxy']['txOrderResponse']['ticketData']['ticket_id'] }
    let(:state) { :valid }
    let(:rendered_ticket) { expected_order_response['TICKeosProxy']['txOrderResponse']['renderedTicket'] }
    let(:ticket_data) { expected_order_response['TICKeosProxy']['txOrderResponse']['ticketData'] }
    let(:aztec_content) { expected_order_response['TICKeosProxy']['txOrderResponse']['aztecContent'] }
    let(:ordering) { expected_order_response['TICKeosProxy']['txOrderResponse']['ordering'] }

    it 'extracts the information from order hash correctly' do
      order
      expect(order.ticket_id).to eq(ticket_id)
      expect(order.state).to eq(state)
      expect(order.rendered_ticket).to eq(rendered_ticket)
      expect(order.ticket_data).to eq(ticket_data)
      expect(order.aztec_content).to eq(aztec_content)
      expect(order.ordering).to eq(ordering)
    end
  end
end
