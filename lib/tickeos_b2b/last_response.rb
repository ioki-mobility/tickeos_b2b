# frozen_string_literal: true

module TickeosB2b
  class LastResponse
    attr_reader :status,
                :headers,
                :body

    def initialize(status:, headers:, body:)
      @status = status
      @headers = headers
      @body = body
    end

    def attributes
      {
        status:  status,
        headers: headers,
        body:    body 
      }
    end
  end
end
