# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TickeosB2b::Client do
  subject(:client) { described_class.new(url, username, password) }

  let(:username) { 'foobar' }
  let(:password) { 'password123' }
  let(:url) { 'https://shop.tickeos.de/service.php/tickeos_proxy' }

  describe '#new' do
    it 'initializes the object correctly' do
      expect(subject).to be_truthy
    end

    it "creates an object of type #{described_class}" do
      expect(subject).to be_an_instance_of(described_class)
    end
  end

  describe '#product_list' do

  end

  describe '#product_data' do

  end

  describe '#purchase' do

  end

  describe '#order' do

  end
end
