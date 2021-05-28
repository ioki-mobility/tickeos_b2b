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
require_relative 'test_run/default_api_response'
require_relative 'test_run/order'
require_relative 'test_run/product_data'
require_relative 'test_run/product_list'
require_relative 'test_run/purchase'

module TickeosB2b
  class Client
    attr_reader :url,
                :username,
                :password,
                :request_body,
                :request_method,
                :response_body,
                :test_run,
                :options,
                :last_request,
                :last_response

    def initialize(url:, username:, password:, test_run: false, options: TestRun::DefaultApiResponse.options)
      @url = URI(url)
      @username = username
      @password = password
      @test_run = test_run
      @options = options
    end

    def product_list
      @request_body = Api::ProductList.request_body
      @request_method = Api::ProductList.request_method

      response = test_run ? TestRun::ProductList.product_list(options) : process_request

      Product.from_json(response: response)
    end

    def load!(product:, full_product_info: false)
      @request_body = Api::ProductData.request_body(reference_id: product.reference_id)
      @request_method = Api::ProductData.request_method

      return process_request if full_product_info & !test_run

      response = test_run ? TestRun::ProductData.load!(options, product.reference_id) : process_request

      Product.load_product_data(
        product:  product,
        response: response
      )
    end

    def purchase(product:, personalisation_data:, requires_zones: false, dry_run: false)
      raise Error::ProductNotFound if product.blank?
      raise Error::PersonalisationDataNotFound if personalisation_data.blank?

      ticket = product.personalize(personalisation_data)

      pre_check = dry_run ? '1' : '0'
      go = dry_run ? '0' : '1'

      @request_body = Api::Purchase.request_body(
        pre_check:      pre_check,
        go:             go,
        ticket:         ticket,
        requires_zones: requires_zones
      )
      @request_method = Api::Purchase.request_method

      response = test_run ? TestRun::Purchase.purchase(options, product.reference_id) : process_request

      Ticket.load_ticket_data(
        ticket:   ticket,
        response: response
      )
    end

    def order(ticket:, part: 'ticket')
      raise Error::TicketNotFound if ticket.blank?

      @request_body = Api::Order.request_body(
        server_ordering_serial:      ticket.server_ordering_serial,
        server_order_product_serial: ticket.server_order_product_serial,
        part:                        part
      )
      @request_method = Api::Order.request_method

      response = test_run ? TestRun::Order.order(options, ticket.product.reference_id) : process_request

      Order.from_json(response: response)
    end

    def cancel(ticket_id:)
      @request_body = Api::Cancel.request_body(
        server_order_product_serial: ticket_id
      )
      @request_method = Api::Cancel.request_method

      response = process_request
      return :error if response.dig('TICKeosProxy', 'txCancelResponse', 'error').present?

      :cancelled
    end

    private

    def process_request
      response = send_request
      response_status = response.status.to_s

      @last_response = LastResponse.new(
        status:  response.status,
        headers: response.headers,
        body:    response.body
      )

      unless response_status.start_with?('2')
        raise Error::Unauthorized if response_status == '401'
        raise Error::Forbidden if response_status == '403'

        raise Error::UnexpectedResponseCode, error_message_from_response(response)
      end

      Nori.new.parse(response.body)
    end

    def connection
      Faraday.new(url: url) do |f|
        f.options[:open_timeout] = 45
        f.options[:timeout] = 45
        f.request :url_encoded
        f.adapter :net_http
        f.basic_auth(username, password)
      end
    end

    def send_request
      if request_method == :get
        send_get_request
      elsif request_method == :post
        send_post_request
      end
    end

    def send_post_request
      connection.post do |request|
        request.headers['Content-Type'] = 'application/xml'
        request.body = request_body
        @last_request = LastRequest.new(
          headers: request.headers,
          body:    request.body,
          options: request.options,
          method:  request.method
        )
      end
    end

    def send_get_request
      connection.get do |request|
        request.headers['Content-Type'] = 'application/xml'
        request.body = request_body
        @last_request = LastRequest.new(
          headers: request.headers,
          body:    request.body,
          options: request.options,
          method:  request.method
        )
      end
    end

    def error_message_from_response(response)
      "#{response.status} >> #{response.body}"
    end
  end
end
