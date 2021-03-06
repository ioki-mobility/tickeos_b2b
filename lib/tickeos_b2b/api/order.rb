# frozen_string_literal: true

module TickeosB2b
  module Api
    class Order
      def self.request_body(server_ordering_serial:, server_order_product_serial:, part:)
        Nokogiri::XML::Builder.new do |xml|
          xml.TICKeosProxy(apiVersion: '', version: '', instanceName: '') do
            xml.txOrderRequest(
              orderingSerial:     server_ordering_serial,
              orderProductSerial: server_order_product_serial
            ) do
              xml.part(part)
              xml.ticketParameter(app: 'mobile', outputFormat: 'png')
            end
          end
        end.to_xml
      end

      def self.request_method
        :get
      end
    end
  end
end
