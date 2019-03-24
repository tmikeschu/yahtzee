module Yahtzee
  module Roller
    def self.roll(quantity)
      Array.new(5 - quantity).map { rand(1..6) }
    end
  end
end
