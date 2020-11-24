# frozen_string_literal: true

require 'securerandom'

module TickeosB2b
  class Product
    ATTRIBUTES = [
      :name,
      :reference_id,
      :updated_at,
      :published,
      :id,
      :vu_name,
      :vu_role,
      :sort_order,
      :tariff_zone_count,
      :tariff_zone_count_required,
      :sale_date_from,
      :sale_date_to,
      :distribution_method,
      :visible
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

    def personalize(personalization_data = {})
      symbolized_personalization_data = personalization_data.map { |k, v| [k.to_sym, v] }.to_h

      ticket                      = Ticket.new(symbolized_personalization_data)
      ticket.product              = self
      ticket.product_reference_id = reference_id
      ticket.serial_ordering      = "ord_#{SecureRandom.uuid}"
      ticket.transaction_id       = "tra_#{SecureRandom.uuid}"

      ticket
    end

    class << self
      def from_json(response:)
        response = response.dig('TICKeosProxy', 'txProductResponse', 'productItem')

        response.map do |product|
          new(
            name:         product['@name'],
            reference_id: product['@reference_id'],
            updated_at:   to_timestamp(product['@updated_at']),
            published:    published?(product['@published'])
          )
        end
      end

      def to_timestamp(time)
        Time.at(time.to_i)
      end

      def published?(product)
        product == '1'
      end

      def load_product_data(product:, response:)
        response = response.dig('TICKeosProxy', 'txProductDataResponse', 'Product')

        product.id                         = response['@id']
        product.vu_name                    = response['@vu_name']
        product.vu_role                    = response['@vu_role']
        product.sort_order                 = response['@sort_order']
        product.tariff_zone_count          = response['@tariff_zone_count']
        product.tariff_zone_count_required = response['@tariff_zone_count_required']
        product.sale_date_from             = to_date(response['@sale_date_from'])
        product.sale_date_to               = to_date(response['@sale_date_to'])
        product.distribution_method        = response['@distribution_method']
        product.visible                    = visible?(response['@visible'])

        product
      end

      def visible?(input)
        input == '1'
      end

      def to_date(input)
        return '' if input.blank?

        Time.parse(DateTime.parse(input).to_s)
      end
    end
  end
end
