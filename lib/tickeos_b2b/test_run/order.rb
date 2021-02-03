# frozen_string_literal: true

module TickeosB2b
  module TestRun
    class Order
      def self.order(options, reference_id)
        options = options.dig(:order, reference_id.to_sym)
        ticket_data = options.dig(:ticket_data)

        Nori.new.parse(
          Nokogiri::XML::Builder.new do |xml|
            xml.TICKeosProxy() do
              xml.txOrderResponse do
                xml.renderedTicket(options[:rendered_ticket])
                xml.ticketData do
                  xml.ticket_id(ticket_data[:ticket_id])
                  xml.ticket_type(ticket_data[:ticket_type])
                  xml.product_name(ticket_data[:product_name])
                  xml.valid_from(ticket_data[:valid_from])
                  xml.price(ticket_data[:price])
                  xml.vat_rate(ticket_data[:vat_rate])
                  xml.currency(ticket_data[:currency])
                end
                xml.aztecContent(options[:aztec_content])
              end
            end
          end.to_xml
        )
      end
    end
  end
end
