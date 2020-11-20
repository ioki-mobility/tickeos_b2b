# frozen_string_literal: true

require 'faraday'
require 'nokogiri'
require 'nori'
require 'uri'

require_relative 'api/cancel'
require_relative 'api/product_list'
require_relative 'api/product_data'
require_relative 'api/purchase'
require_relative 'api/order'

module TickeosB2b
  class Client
    attr_reader :url,
                :username,
                :password,
                :request_body,
                :request_method

    def initialize(url:, username:, password:)
      @url = URI(url)
      @username = username
      @password = password
    end

    def product_list
      @request_body = Api::ProductList.request_body
      @request_method = Api::ProductList.request_method

      Product.from_json(response: call)
    end

    def load!(product:, full_product_info: false)
      @request_body = Api::ProductData.request_body(reference_id: product.reference_id)
      @request_method = Api::ProductData.request_method

      return call if full_product_info

      Product.load_product_data(
        product:  product,
        response: call
      )
    end

    def validate
    end

    def purchase(product:, personalisation_data:, dry_run: false)
      raise Error::ProductNotFound if product.blank?
      raise Error::PersonalisationDataNotFound if personalisation_data.blank?

      ticket = product.personalize(personalisation_data)
      pre_check = pre_check_settings(dry_run)[:pre_check]
      go = pre_check_settings(dry_run)[:go]

      @request_body = Api::Purchase.request_body(pre_check: pre_check, go: go, ticket: ticket)
      @request_method = Api::Purchase.request_method

      Ticket.load_ticket_data(ticket: ticket, response: call)
    end

    def order(ticket:)
      raise Error::TicketNotFound if ticket.blank?

      @request_body = Api::Order.request_body(
        server_ordering_serial:      ticket.server_ordering_serial,
        server_order_product_serial: ticket.server_order_product_serial
      )
      @request_method = Api::Order.request_method

      Order.from_json(response: call)
    end

    def cancel(ticket_id:)
      @request_body = Api::Cancel.request_body(
        server_order_product_serial: ticket_id
      )
      @request_method = Api::Cancel.request_method

      result = call
      return :error unless result.dig('TICKeosProxy', 'txCancelResponse', 'error').blank?

      :cancelled
    end

    private

    def call
      response = process_request
      response_status = response.status.to_s

      unless response_status.start_with?('2')
        raise Error::Unauthorized if response_status == '401'
        raise Error::Forbidden if response_status == '403'

        raise Error::UnexpectedResponseCode, error_message_from_response(response)
      end

      parsed_response = Nori.new.parse(response.body)
      parsed_response
    end

    def connection
      Faraday.new(url: url) do |f|
        f.options[:open_timeout] = 5
        f.options[:timeout] = 15
        f.request :url_encoded
        f.adapter :net_http
        f.basic_auth(username, password)
      end
    end

    def process_request
      if request_method == :get
        process_get_request
      elsif request_method == :post
        process_post_request
      end
    end

    def process_post_request
      connection.post do |request|
        request.headers['Content-Type'] = 'application/xml'
        request.body = request_body
      end
    end

    def process_get_request
      connection.get do |request|
        request.headers['Content-Type'] = 'application/xml'
        request.body = request_body
      end
    end

    def error_message_from_response(response)
      "#{response.status} >> #{response.body}"
    end

    def pre_check_settings(dry_run)
      return { pre_check: '1', go: '0' } if dry_run

      { pre_check: '0', go: '1' }
    end
  end
end
