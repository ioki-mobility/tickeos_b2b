# frozen_string_literal: true

module TickeosB2b
  class Purchase
    def self.request_body(pre_check, go, **options)
      Nokogiri::XML::Builder.new do |xml|
        xml.TICKeosProxy(apiVersion: '', version: '', instanceName: '') do
          xml.txPurchaseRequest(preCheck: pre_check, go: go) do
            xml.ordering(serial_number: options[:serial_ordering], app: 'mobile')
            xml.orderCustomer(
              serial_number: '',
              salutation:    '',
              first_name:    options[:first_name],
              last_name:     options[:last_name],
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
              reference_id:  options[:ref_id],
              quantity:      options[:quantity],
              serial_number: options[:serial_product]
            ) do
              xml.validationDate(timestamp: validation_date(options[:date_to_validate]))
              xml.location(id: options[:location_id])
              xml.validationEndDate(timestamp: '')
              xml.zone(value: '')
              xml.zone(value: '')
              xml.personalisation(role: 'first_name', type: 'plain') do
                xml.value(options[:first_name])
              end
              xml.personalisation(role: 'last_name', type: 'plain') do
                xml.value(options[:last_name])
              end
              xml.subProductSelections(productTypeRole: 'subproduct') do
                xml.subProductSelection(
                  reference_id:  options[:sub_ref_id],
                  serial_number: '',
                  quantity:      ''
                ) do
                  xml.validationEndDate(timestamp: '')
                end
              end
            end
            xml.payment(
              transaction_id: options[:transaction_id],
              payed_amount:   options[:payed_amount],
              method_detail:  ''
            )
          end
        end
      end.to_xml
    end

    def self.validation_date(date_to_validate)
      return '' if date_to_validate.blank?

      date_to_validate.strftime('%Y-%m-%d')
    end

    def self.request_method
      :post
    end
  end
end
