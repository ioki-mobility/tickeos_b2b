# frozen_string_literal: true

module TickeosB2b
  class Order
    ATTRIBUTES = [
      :ticket_id,
      :state,
      :rendered_ticket,
      :ticket_data,
      :aztec_content
    ].freeze

    attr_accessor(*ATTRIBUTES)

    def initialize(**kwargs)
      ATTRIBUTES.each do |attr|
        instance_variable_set("@#{attr}", kwargs[attr])
      end
    end

    def attributes
      ATTRIBUTES.map do |attr|
        [attr, public_send(attr)]
      end.to_h
    end

    def self.from_json(json)
      json = json.dig('TICKeosProxy', 'txOrderResponse')

      new(
        ticket_id:       json.dig('ticketData', 'ticket_id'),
        state:           :valid,
        rendered_ticket: json.dig('renderedTicket'),
        ticket_data:     json.dig('ticketData'),
        aztec_content:   json.dig('aztecContent')
      )
    end
  end
end
