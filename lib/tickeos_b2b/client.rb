# frozen_string_literal: true

require 'faraday'
require 'nokogiri'
require 'nori'
require 'uri'

require_relative 'product_list'
require_relative 'product_data'
require_relative 'purchase'
require_relative 'order'

module TickeosB2b
  class Client
    attr_reader :url,
                :username,
                :password,
                :request_body,
                :request_method

    def initialize(url, username, password)
      @url = URI(url)
      @username = username
      @password = password
    end

    def product_list
      @request_body = TickeosB2b::ProductList.request_body
      @request_method = TickeosB2b::ProductList.request_method

      call
    end

    def product_data(ref_id)
      @request_body = TickeosB2b::ProductData.request_body(ref_id)
      @request_method = TickeosB2b::ProductData.request_method

      call
    end

    def purchase(pre_check = 0, go = 1, **options)
      @options = options
      @request_body = TickeosB2b::Purchase.request_body(pre_check, go, options)
      @request_method = TickeosB2b::Purchase.request_method

      call
    end

    def order(server_ordering_serial, server_order_product_serial)
      @request_body = TickeosB2b::Order.request_body(server_ordering_serial, server_order_product_serial)
      @request_method = TickeosB2b::Order.request_method

      call
    end

    private

    def call
      response = process_request

      unless [200].include?(response.status)
        raise Error::Unauthorized if response.status == 401
        raise Error::Forbidden if response.status == 403
      end

      Nori.new.parse(response.body)
    end

    def connection
      Faraday.new(url: url) do |f|
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
  end
end
