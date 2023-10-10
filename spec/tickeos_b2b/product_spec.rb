require 'spec_helper'

RSpec.describe TickeosB2b::Product do
  let(:product_list_json) do
    Nori.new.parse(
      <<~XML
        <?xml version="1.0"?>
        <TICKeosProxy apiVersion="1.0" version="2012.12" instanceName="tickeos-test">
          <txProductResponse method="product_list">
            <productItem name="EinzelTagesTicket" reference_id="einzeltagesticket_print" updated_at="1354181759" published="1"/>
            <productItem name="EinzelTagesTicket" reference_id="einzeltagesticket_mobil" updated_at="1354181759" published="1"/>
            <productItem name="GruppenTagesTicket" reference_id="gruppentagesticket_mobil" updated_at="1354181759" published="1"/>
            <productItem name="KurzstreckenTicket" reference_id="kurzstreckenticket_mobil" updated_at="1353073483" published="1"/>
            <productItem name="EinzelTicket Erw." reference_id="einzelticket_erw_mobil" updated_at="1353079377" published="1"/>
            <productItem name="EinzelTicket Kind" reference_id="einzelticket_kind_mobil" updated_at="1353079375" published="1"/>
          </txProductResponse>
        </TICKeosProxy>
      XML
    )
  end

  let(:product_data_json) do
    Nori.new.parse(
      <<~XML
        <?xml version="1.0"?>
        <TICKeosProxy apiVersion="1.0" version="2013.09" instanceName="tickeos">
          <txProductDataResponse productReferenceId="" timeIntervalOptionType="type">
            <Product id="113" reference_id="24h_name_karte" vu_name="name vu" vu_role="role" sort_order="10" tariff_zone_count="0" tariff_zone_count_required="0" sale_date_from="" sale_date_to="" distribution_method="print" visible="1">
              <I18n name="24-h name Karte f&#xFC;r alle &#xF6;ffentlichen Verkehrsmittel" name_matching="24-h name Karte f&#xFC;r alle &#xF6;ffentlichen Verkehrsmittel" tariff_zones_label="Zonen" is_visible="true" culture="de">
                <descriptionShort>G&#xFC;ltig f&#xFC;r 24 Stunden ab angegebenem Datum und Uhrzeit auf allen &#xF6;ffentlichen Verkehrsmitteln in name.</descriptionShort>
                <descriptionDetailed>24-h name Karte Ideal f&#xFC;r Besucher, die innerhalb k&#xFC;rzester Zeit m&#xF6;glichst viel von der Stadt sehen wollen. G&#xFC;ltig f&#xFC;r 24 Stunden ab angegebenem Datum und Uhrzeit G&#xFC;ltig auf allen &#xF6;ffentlichen Verkehrsmitteln in name Kartenkauf max. 30 Tage vor G&#xFC;ltigkeitsbeginn m&#xF6;glich Besondere Nutzungsbestimmungen </descriptionDetailed>
              </I18n>
              <I18n name="24-h name Ticket for all public transports" name_matching="24-h name Karte f&#xFC;r alle &#xF6;ffentlichen Verkehrsmittel" tariff_zones_label="Zones" is_visible="true" culture="en">
                <descriptionShort>For any rides from valididy date and time on all public transports.</descriptionShort>
                <descriptionDetailed>24-h name Ticket {desc en} </descriptionDetailed>
              </I18n> 
              <layoutBlock>
                <I18n headline="" hint_text="" culture="de"/>
                <I18n headline="" hint_text="" culture="en"/>
                <layoutField type="fixed" name="product">
                  <I18n label="Ticket" culture="de"/>
                  <I18n label="Ticket" culture="en"/>
                </layoutField>
                <layoutField type="fixed" name="validation_date">
                  <I18n label="G&#xFC;ltig am/ab" culture="de"/>
                  <I18n label="valid from" culture="en"/>
                  <content type="date" days_in_future="30" days_in_past="0" date_min="" date_max="" interval="Zeitpunkt Viertel" default_time="" calendrical_period_due_date=""/>
                </layoutField>
              </layoutBlock>
              <layoutBlock>
                <I18n headline="Personalisierung" hint_text="" culture="de"/>
                <I18n headline="Personalisation" hint_text="" culture="en"/>
                <layoutField type="personalization_property" name="first_name">
                  <I18n label="Vorname" culture="de"/>
                  <I18n label="First Name" culture="en"/>
                  <content type="text" required="yes"/>
                </layoutField>
                <layoutField type="personalization_property" name="last_name">
                  <I18n label="Nachname" culture="de"/>
                  <I18n label="Last Name" culture="en"/>
                  <content type="text" required="yes"/>
                </layoutField>
              </layoutBlock>
            </Product>
          </txProductDataResponse>
        </TICKeosProxy>
      XML
    )
  end

  let(:product_list) do
    described_class.from_json(
      response: product_list_json
    )
  end

  describe '.new' do
    it 'creates a new Product object' do
      expect(described_class.new).to be_an_instance_of(TickeosB2b::Product)
    end
  end

  describe '.attributes' do
    let(:expected_attributes) do
      {
        name:                       nil,
        reference_id:               nil,
        updated_at:                 nil,
        published:                  nil,
        id:                         nil,
        vu_name:                    nil,
        vu_role:                    nil,
        sort_order:                 nil,
        tariff_zone_count:          nil,
        tariff_zone_count_required: nil,
        sale_date_from:             nil,
        sale_date_to:               nil,
        distribution_method:        nil,
        visible:                    nil
      }
    end

    it 'returns the Product attributes correctly' do
      expect(described_class.new.attributes).to eq(expected_attributes)
    end
  end

  describe '.personalize' do
    let(:personalisation_data) do
      {
        first_name:      'Json',
        last_name:       'Statham',
        validation_date: ActiveSupport::TimeZone['Europe/Berlin'].local(2020, 9, 2, 23, 0, 0),
        sub_ref_id:      'kein Zuschlag'
      }
    end

    it 'personalizes a Ticket and adds the Product' do
      product = product_list.first
      ticket = product.personalize(personalisation_data)

      expect(ticket.state).to eq(:new)
      expect(ticket.product).to eq(product)
      expect(ticket.product_reference_id).to eq(product.reference_id)
    end
  end

  describe '.from_json' do
    it 'extracts the information from product_list hash correctly' do
      expect(product_list.count).to eq(6)

      product = product_list.first
      expect(product.name).to eq('EinzelTagesTicket')
      expect(product.reference_id).to eq('einzeltagesticket_print')
      expect(product.updated_at).to eq(Time.new(2012, 11, 29, 10, 35, 59, '+01:00'))
      expect(product.published).to eq(true)

      product = product_list.last
      expect(product.name).to eq('EinzelTicket Kind')
      expect(product.reference_id).to eq('einzelticket_kind_mobil')
      expect(product.updated_at).to eq(Time.new(2012, 11, 16, 16, 22, 55, '+01:00'))
      expect(product.published).to eq(true)
    end
  end

  describe '.load_product_data' do
    it 'updates the Product data correctly' do
      product = product_list.first
      product = described_class.load_product_data(
        product:  product,
        response: product_data_json
      )
      expect(product.id).to eq('113')
      expect(product.vu_name).to eq('name vu')
      expect(product.vu_role).to eq('role')
      expect(product.sort_order).to eq('10')
      expect(product.tariff_zone_count).to eq('0')
      expect(product.tariff_zone_count_required).to eq('0')
      expect(product.sale_date_from).to eq('')
      expect(product.sale_date_to).to eq('')
      expect(product.distribution_method).to eq('print')
      expect(product.visible).to eq(true)
    end
  end
end
