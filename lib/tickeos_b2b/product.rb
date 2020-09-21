# frozen_string_literal: true

module TickeosB2b
  class Product
    ATTRIBUTES = [
      :name,
      :reference_id,
      :updated_at,
      :published,
      :id
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

    class << self
      def from_json(json)
        json = json['TICKeosProxy']['txProductResponse']['productItem']

        json.map do |product|
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
    end
  end
end
