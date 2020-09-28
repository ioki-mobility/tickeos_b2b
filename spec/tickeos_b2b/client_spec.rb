# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TickeosB2b::Client do
  subject(:client) { described_class.new(tickeos_url, username, password) }

  let(:username) { 'foobar' }
  let(:password) { 'password123' }
  let(:tickeos_url) { 'https://shop.tickeos.de/service.php/tickeos_proxy' }

  describe '#new' do
    it 'initializes the object correctly' do
      expect(subject).to be_truthy
    end

    it "creates an object of type #{described_class}" do
      expect(subject).to be_an_instance_of(described_class)
    end
  end

  describe 'endpoint methods' do
    before do
      stub_request(:get, tickeos_url).
        with(body:    request_body,
             headers: {
               'Content-Type' => 'application/xml'
             }).
        to_return(status: 200, body: '')
    end

    describe '#product_list' do
      let(:request_body) do
        Nokogiri::XML::Builder.new do |xml|
          xml.TICKeosProxy(apiVersion: '', version: '', instanceName: '') do
            xml.txProductRequest(method: 'product_list')
          end
        end.to_xml
      end

      it 'is expected to succeed' do
      end
    end

    describe '#product_data' do
      let(:ref_id) { 'Ticket' }

      let(:request_body) do
        Nokogiri::XML::Builder.new do |xml|
          xml.TICKeosProxy(apiVersion: '', version: '', instanceName: '') do
            xml.txProductDataRequest(productReferenceId: ref_id, timeIntervalOptionType: 'type')
          end
        end.to_xml
      end

      it 'is expected to succeed' do
        expect { client.product_data(ref_id).not_to raise_error }
      end
    end

    describe '#purchase' do
    end

    describe '#order' do
    end
  end
end
