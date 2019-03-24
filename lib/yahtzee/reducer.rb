require "yahtzee/roller"
require "yahtzee/utils"

module Yahtzee
  module Reducer
    class << self
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
        {
          status: :roll_1,
          current_hand: Roller.roll(state.fetch(:held_dice).length),
        }
      end

      def exit(state, _)
        {status: :game_over}
      end

      def restart(state, _)
        initial_state(state.fetch(:static))
      end

      def noop(state, _)
        {}
      end

      def roll_selection(state, payload)
        selection = payload.fetch(:parsed)
        current_hand = state.fetch(:current_hand)

        selected_count = Utils.frequencies(selection)
        current_count = Utils.frequencies(current_hand)

        if selected_count.all? { |(k, v)| v <= current_count.fetch(k) }
          state.fetch(:held_dice)
            .concat(selection)
            .then { |held_dice|
            {
              held_dice: held_dice,
              current_hand: Roller.roll(state.fetch(:held_dice).length),
              status: next_roll(state.fetch(:status)),
            }
          }
        else
          {
            notice: :invalid_selection,
          }
        end
      end

      def next_roll(status)
        {
          roll_1: :roll_2,
          roll_2: :roll_3,
          roll_3: :roll_1,
        }.fetch(status, :noop)
      end
    end
  end
end
