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
  end
end
