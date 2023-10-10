# frozen_string_literal: true

module TickeosB2b
  module TestRun
    class ProductData
      def self.load!(options, reference_id)
        options = options.dig(:product_data, reference_id.to_sym)

        return Error if options.nil?

        Nori.new.parse(
          Nokogiri::XML::Builder.new do |xml|
            xml.TICKeosProxy(apiVersion: '1.0', version: ActiveSupport::TimeZone['Berlin'].now.strftime('%Y-%m-%d'), instanceName: 'test') do
              xml.txProductDataResponse(productReferenceId: '', timeIntervalOptionType: 'type') do
                xml.Product(
                  id:                         options[:id],
                  vu_name:                    options[:vu_name],
                  vu_role:                    options[:vu_role],
                  sort_order:                 options[:sort_order],
                  tariff_zone_count:          options[:tariff_zone_count],
                  tariff_zone_count_required: options[:tariff_zone_count_required],
                  sale_date_from:             options[:sale_date_from],
                  sale_date_to:               options[:sale_date_to],
                  distribution_method:        options[:distribution_method],
                  visible:                    options[:visible]
                )
              end
            end
          end.to_xml
        )
      end
    end
  end
end
