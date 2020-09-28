# frozen_string_literal: true

require 'base64'

module TickeosB2b
  class Order
    ATTRIBUTES = [
      :ticket_id,
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
      json = json['TICKeosProxy']['txOrderResponse']

      new(
        ticket_id:     json['ticketData']['ticket_id'],
        ticket_data:   json['ticketData'],
        aztec_content: decode(json['aztecContent'])
      )
    end

    def self.decode(content)
      Base64.decode64(content)
    end
  end
end
