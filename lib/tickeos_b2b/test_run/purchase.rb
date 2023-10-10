# frozen_string_literal: true

module TickeosB2b
  module TestRun
    class Purchase
      def self.purchase(options, reference_id)
        options = options.dig(:purchase, reference_id.to_sym)

        Nori.new.parse(
          Nokogiri::XML::Builder.new do |xml|
            xml.TICKeosProxy(apiVersion: '1.0', version: ActiveSupport::TimeZone['Berlin'].now.strftime('%Y-%m-%d'), instanceName: 'test') do
              xml.txPurchaseResponse do
                xml.ordering(server_ordering_serial: options[:server_ordering_serial])
                xml.productData(
                  server_order_product_serial: options[:server_order_product_serial],
                  price_net:                   options[:price_net],
                  price_gross:                 options[:price_gross],
                  price_vat:                   options[:price_vat],
                  price_vat_rate:              options[:price_vat_rate]
                )
              end
            end
          end.to_xml
        )
      end
    end
  end
end
