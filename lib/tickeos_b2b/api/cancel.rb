# frozen_string_literal: true

module TickeosB2b
  module Api
    class Cancel
      def self.request_body(server_order_product_serial:, go: '1')
        Nokogiri::XML::Builder.new do |xml|
          xml.TICKeosProxy(apiVersion: '', version: '', instanceName: '') do
            xml.txCancelRequest(
              go:                 go,
              context:            'merchant',
              orderProductSerial: server_order_product_serial
            )
          end
        end.to_xml
      end

      def self.request_method
        :post
      end
    end
  end
end
