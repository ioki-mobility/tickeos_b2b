# frozen_string_literal: true

module TickeosB2b
  class LastRequest
    attr_reader :headers,
                :body,
                :options,
                :method

    def initialize(headers:, body:, options:, method:)
      @headers = headers
      @body = body
      @options = options
      @method = method
    end

    def attributes
      {
        headers: headers,
        body:    body,
        options: options,
        method:  method
      }
    end
  end
end
