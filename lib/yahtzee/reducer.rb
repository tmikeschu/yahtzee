module Yahtzee
  module Reducer
    class << self
      SINGLES = %i[ones twos threes fours fives sixes]
      DEFAULT_DISPATCH = {message: :noop, payload: {}}

      HANDS = SINGLES.concat(%i[
        three_kind
        four_kind
        small_straight
        large_straight
        full_house
        chance
        yahtzee
      ])

      def initial_state(static)
        {
          static: static,
          hands: HANDS.reduce({}) { |acc, el| acc.merge(el => nil) },
          rolls: 0,
          current_hand: [],
          held_dice: [],
          status: :not_started,
          error: nil,
        }
      end

      def start_game(state, payload)
        state.merge(status: :roll_1)
      end

      def exit(state, _)
        state.merge(status: :game_over)
      end

      def restart(state, _)
        initial_state(state.fetch(:static))
      end

      def noop(state, _)
        state
      end
    end
  end
end
