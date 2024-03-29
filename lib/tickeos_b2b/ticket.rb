# frozen_string_literal: true

require 'active_support/core_ext/time'

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

    DATE_REGEX = /\A\d{4}-\d{2}-\d{2}\Z/
    VALID_TIME_ZONES = %w[CET CEST].freeze

    attr_accessor(*ATTRIBUTES)

    def initialize(**kwargs)
      ATTRIBUTES.each do |attr|
        public_send("#{attr}=", kwargs[attr])
      end

      self.state = :new
    end

    def attributes
      ATTRIBUTES.map do |attr|
        [attr, public_send(attr)]
      end.to_h
    end

    # a validation date will always be transformed to a valid Date or Time object whenever possible.
    # Time object must also have a timezone included to prevent misinterpretations for the according validation_date.
    # E.g.: During german summertime someone buys a ticket at/for 1:00am. In UTC resspecting the timezone offset the date
    #       of the previous day would be applied, causing for the ticket not to be offered.
    def validation_date=(value)
      value = if value.blank?
                nil
              elsif DATE_REGEX.match(value.to_s)
                Date.parse(value.to_s)
              elsif value.is_a?(Time)
                assert_timezone!(value)
              else
                time = Time.parse(value.to_s)
                assert_timezone!(time)
              end

      @validation_date = value
    end

    def assert_timezone!(time)
      valid_timezone = VALID_TIME_ZONES.include?(time.zone) ||
                       time.in_time_zone(ActiveSupport::TimeZone['Berlin']).utc_offset == time.utc_offset

      raise ArgumentError, 'Time without CET/CEST timezone is not supported' unless valid_timezone

      time
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
