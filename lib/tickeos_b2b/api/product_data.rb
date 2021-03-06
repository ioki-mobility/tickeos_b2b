# frozen_string_literal: true

module TickeosB2b
  module Api
    class ProductData
      def self.request_body(reference_id:)
        Nokogiri::XML::Builder.new do |xml|
          xml.TICKeosProxy(apiVersion: '', version: '', instanceName: '') do
            xml.txProductDataRequest(productReferenceId: reference_id, timeIntervalOptionType: 'type')
          end
        end.to_xml
      end

      def self.request_method
        :get
      end
    end
  end
end
