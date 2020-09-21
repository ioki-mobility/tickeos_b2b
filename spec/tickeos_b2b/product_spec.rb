require 'spec_helper'

RSpec.describe TickeosB2b::Product do
  let(:product_list) do
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

  let(:products) { described_class.from_json(product_list) }

  describe '.from_json' do
    it 'extracts correct information from product_list hash' do
      expect(products.count).to eq(6)

      product = products.first
      expect(product.name).to eq('EinzelTagesTicket')
      expect(product.reference_id).to eq('einzeltagesticket_print')
      expect(product.updated_at).to eq(Time.new(2012, 11, 29, 10, 35, 59, '+01:00'))
      expect(product.published).to eq(true)

      product = products.last
      expect(product.name).to eq('EinzelTicket Kind')
      expect(product.reference_id).to eq('einzelticket_kind_mobil')
      expect(product.updated_at).to eq(Time.new(2012, 11, 16, 16, 22, 55, '+01:00'))
      expect(product.published).to eq(true)
    end
  end
end
