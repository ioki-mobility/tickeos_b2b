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
      :location_id,
      :start_zone,
      :end_zone,
      :product_type_role,
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

    def self.load_ticket_data(ticket:, response:)
      response = response.dig('TICKeosProxy', 'txPurchaseResponse') || response.dig('TICKeosProxy', 'txResponse')

      ticket.server_ordering_serial      = nil
      ticket.server_order_product_serial = nil
      ticket.price_net                   = nil
      ticket.price_gross                 = nil
      ticket.price_vat                   = nil
      ticket.price_vat_rate              = nil

      unless response['error'].blank?
        ticket.state                       = :invalid
        ticket.errors                      = {
          error_type:    :standard,
          error_code:    response.dig('error', 'detail', '@error_code') || response.dig('error', '@code'),
          error_message: response.dig('error', 'detail', '@error_message') || response.dig('error', '@message')
        }

        return ticket
      end

      unless response['validationError'].blank?
        ticket.state                       = :invalid
        ticket.errors                      = {
          error_type:     :validation_error,
          error_product:  response.dig('validationError', 'productError'),
          error_payment:  response.dig('validationError', 'paymentError'),
          error_customer: response.dig('validationError', 'customerError'),
          error_code:     response.dig('validationError', '@code'),
          error_message:  response.dig('validationError', '@message')
        }

        return ticket
      end

      ticket.state                       = :purchased
      ticket.server_ordering_serial      = response.dig('ordering', '@server_ordering_serial')
      ticket.server_order_product_serial = response.dig('productData', '@server_order_product_serial')
      ticket.price_net                   = response.dig('productData', '@price_net').to_f
      ticket.price_gross                 = response.dig('productData', '@price_gross').to_f
      ticket.price_vat                   = response.dig('productData', '@price_vat').to_f
      ticket.price_vat_rate              = response.dig('productData', '@price_vat_rate').to_f

      ticket
    end
  end
end
