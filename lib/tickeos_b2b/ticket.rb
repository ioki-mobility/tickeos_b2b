# frozen_string_literal: true

module TickeosB2b
  class Ticket
    ATTRIBUTES = [
      :state,
      :product,
      :product_reference_id,
      :errors,
      :serial_ordering,
      :transaction_id,
      :sub_ref_id,
      :validation_date,
      :first_name,
      :last_name,
      :server_ordering_serial,
      :server_order_product_serial,
      :price_net,
      :price_gross,
      :price_vat,
      :price_vat_rate
    ].freeze

    attr_accessor(*ATTRIBUTES)

    def initialize(**kwargs)
      ATTRIBUTES.each do |attr|
        instance_variable_set("@#{attr}", kwargs[attr])
      end

      self.state = :new
    end

    def attributes
      ATTRIBUTES.map do |attr|
        [attr, public_send(attr)]
      end.to_h
    end

    def self.load_ticket_data(ticket, json)
      json = json['TICKeosProxy']['txPurchaseResponse']

      ticket.server_ordering_serial      = nil
      ticket.server_order_product_serial = nil
      ticket.price_net                   = nil
      ticket.price_gross                 = nil
      ticket.price_vat                   = nil
      ticket.price_vat_rate              = nil

      unless json['error'].blank?
        ticket.state                       = :invalid
        ticket.errors                      = {
          error_type:    :standard,
          error_code:    json['error']['detail']['@error_code'],
          error_message: json['error']['detail']['@error_message']
        }

        return ticket
      end

      unless json['validationError'].blank?
        ticket.state                       = :invalid
        ticket.errors                      = {
          error_type:     :validation_error,
          error_product:  json['validationError']['productError'],
          error_payment:  json['validationError']['paymentError'],
          error_customer: json['validationError']['customerError'],
          error_code:     json['validationError']['@code'],
          error_message:  json['validationError']['@message']
        }

        return ticket
      end

      ticket.state                       = :purchased
      ticket.server_ordering_serial      = json['ordering']['@server_ordering_serial']
      ticket.server_order_product_serial = json['productData']['@server_order_product_serial']
      ticket.price_net                   = json['productData']['@price_net'].to_f
      ticket.price_gross                 = json['productData']['@price_gross'].to_f
      ticket.price_vat                   = json['productData']['@price_vat'].to_f
      ticket.price_vat_rate              = json['productData']['@price_vat_rate'].to_f

      ticket
    end
  end
end
