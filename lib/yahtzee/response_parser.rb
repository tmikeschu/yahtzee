module Yahtzee
  module ResponseParser
    class << self
      def digits
        ->(raw) {raw.scan(/\d/).map(&:to_i)}
      end
    end
  end
end
