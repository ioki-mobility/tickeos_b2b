# frozen_string_literal: true

module TickeosB2b
  class Order
    ATTRIBUTES = [
      :ticket_id,
      :state,
      :rendered_ticket,
      :ticket_data,
      :aztec_content,
      :ordering
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

    def self.from_json(response:)
      response = response.dig('TICKeosProxy', 'txOrderResponse')

      new(
        ticket_id:       response.dig('ticketData', 'ticket_id'),
        state:           :valid,
        rendered_ticket: response.dig('renderedTicket'),
        ticket_data:     response.dig('ticketData'),
        aztec_content:   response.dig('aztecContent'),
        ordering:        response.dig('ordering')
      )
    end
  end
end
