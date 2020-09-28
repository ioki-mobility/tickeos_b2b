# frozen_string_literal: true

module TickeosB2b
  module Error
    class TickeosError < StandardError
    end

    class Unauthorized < TickeosError
    end

    class Forbidden < TickeosError
    end

    class UnexpectedResponseCode < TickeosError
    end

    class NoProductFound < TickeosError
      def intialize(msg = 'Please provide a product.')
        super
      end
    end

    class NoPersonalisationDataFound < TickeosError
      def initialize(msg = 'Please provide personalisation data.')
        super
      end
    end

    class NoTicketFound < TickeosError
      def initialize(msg = 'Please provide a ticket.')
        super
      end
    end
  end
end
