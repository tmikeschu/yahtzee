module Yahtzee
  class Store
    SINGLES = %i[ones twos threes fours fives sixes]

    HANDS = SINGLES.concat(%i[
      three_kind
      four_kind
      small_straight
      large_straight
      full_house
      chance
      yahtzee
    ])

    attr_reader :state

    def initialize(static = {})
      @state = initial_state(static)
    end

    def total_score
      state.
        fetch(:hands, {}).
        values.
        sum(&:to_i)
    end

    private

    def initial_state(static)
      {
        static: static,
        hands: HANDS.reduce({}) { |acc, el| acc.merge(el => nil) },
        rolls: 0,
        current_hand: [],
        held_dice: [],
      }
    end
  end
end
