module Yahtzee
  module Roller
    def self.roll(offset)
      Array.new(5 - offset).map { rand(1..6) }
    end
  end
end
