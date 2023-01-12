# frozen_string_literal: true

module TickeosB2b
  module Api
    class Purchase
      def self.request_body(pre_check:, go:, ticket:, requires_zones:)
        Nokogiri::XML::Builder.new do |xml|
          xml.TICKeosProxy(apiVersion: '', version: '', instanceName: '') do
            xml.txPurchaseRequest(preCheck: pre_check, go: go) do
              xml.ordering(serial_number: ticket.serial_ordering, app: 'mobile')
              xml.orderCustomer(
                serial_number: '',
                salutation:    '',
                first_name:    ticket.first_name,
                last_name:     ticket.last_name,
                email:         '',
                birthday:      '',
                street:        '',
                street_number: '',
                postal_code:   '',
                city:          '',
                country:       ''
              ) do
                xml.title(value: '')
                xml.identityCard(ref_id: 'p', name: 'Personalausweis', value: '', number: '')
              end
              xml.optionProduct(
                reference_id:  ticket.product.reference_id,
                quantity:      '1',
                serial_number: ticket.product.id
              ) do
                xml.validationDate(timestamp: validation_date(ticket.validation_date))
                xml.validationEndDate(timestamp: '')
                xml.location(id: ticket.location_id)
                if requires_zones
                  xml.zone(value: ticket.start_zone || '')
                  xml.zone(value: ticket.end_zone || '')
                end
                xml.personalisation(role: 'first_name', type: 'plain') do
                  xml.value(ticket.first_name)
                end
                xml.personalisation(role: 'last_name', type: 'plain') do
                  xml.value(ticket.last_name)
                end
                xml.subProductSelections(productTypeRole: ticket.product_type_role) do
                  xml.subProductSelection(
                    reference_id:  ticket.sub_ref_id,
                    serial_number: '',
                    quantity:      '1'
                  ) do
                    xml.validationEndDate(timestamp: '')
                  end
                end
              end
              xml.payment(
                transaction_id: ticket.transaction_id,
                payed_amount:   '',
                method_detail:  ''
              )
            end
          end
        end.to_xml
      end

      def self.validation_date(datetime)
        return '' if datetime.blank?

        datetime.to_date.to_s
      end

      def self.request_method
        :post
      end
    end
  end
end
