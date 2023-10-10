# frozen_string_literal: true

module TickeosB2b
  module TestRun
    class ProductList
      def self.product_list(options = {})
        options = options.transform_keys(&:to_sym).dig(:product_list)

        Nori.new.parse(
          Nokogiri::XML::Builder.new do |xml|
            xml.TICKeosProxy(apiVersion: '1.0', version: ActiveSupport::TimeZone['Berlin'].now.strftime('%Y-%m-%d'), instanceName: 'test') do
              xml.txProductResponse(method: 'product_list') do
                options.each do |opt|
                  opt = opt.transform_keys(&:to_sym)
                  xml.productItem(
                    name:         opt[:name],
                    reference_id: opt[:reference_id],
                    updated_at:   '1354181759',
                    published:    '1'
                  )
                end
              end
            end
          end.to_xml
        )
      end
    end
  end
end
