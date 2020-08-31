# frozen_string_literal: true

module TickeosB2b
  class ProductList
    def self.request_body
      Nokogiri::XML::Builder.new do |xml|
        xml.TICKeosProxy(apiVersion: '', version: '', instanceName: '') do
          xml.txProductRequest(method: 'product_list')
        end
      end.to_xml
    end

    def self.request_method
      :get
    end
  end
end
