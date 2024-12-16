# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TickeosB2b::Client do
  subject(:client) do
    described_class.new(
      url:      tickeos_url,
      username: username,
      password: password
    )
  end

  let(:username) { nil }
  let(:password) { 'password123' }
  let(:tickeos_url) { 'https://shop.tickeos.de/service.php/tickeos_proxy' }

  describe '#new' do
    it 'creates an object of type TickeosB2b::Client' do
      expect(client).to be_an_instance_of(described_class)
    end
  end

  describe '#product_list' do
    let(:response_body) do
      'Example'
    end

    before do
      stub_request(:get, 'https://shop.tickeos.de/service.php/tickeos_proxy').
        with(
          headers: {
            'Accept'          => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Authorization'   => 'Basic OnBhc3N3b3JkMTIz',
            'Content-Type'    => 'application/xml',
            'User-Agent'      => 'Faraday v1.0.1'
          }
        ).to_return(status: 200, body: response_body, headers: {})
    end

    it do
      expect(TickeosB2b::Api::ProductList).to receive(:request_body)
      client.product_list
    end

    it do
      expect(TickeosB2b::Product).to receive(:from_json)
      client.product_list
    end
  end

#      let(:product_list_double) do
#        double(
#          described_class,
#          
#        )
#      end
#      let(:product_list) do
#        'gandlkfa'
#      end




#      let(:request_body) do
#        Nokogiri::XML::Builder.new do |xml|
#          xml.TICKeosProxy(apiVersion: '', version: '', instanceName: '') do
#            xml.txProductRequest(method: 'product_list')
#          end
#        end.to_xml
#      end

      # it 'is expected to succeed' do
      #   ap client.product_list
      #   #expect(client.product_list).to eq(product_list)
      # end
#    end

    describe '#product_data' do
      let(:ref_id) { 'Ticket' }

      let(:request_body) do
        Nokogiri::XML::Builder.new do |xml|
          xml.TICKeosProxy(apiVersion: '', version: '', instanceName: '') do
            xml.txProductDataRequest(productReferenceId: ref_id, timeIntervalOptionType: 'type')
          end
        end.to_xml
      end

      # it 'is expected to succeed' do
      #   expect { client.product_data(ref_id).not_to raise_error }
      # end
    end

    describe '#purchase' do
    end

    describe '#order' do
    end
  end
