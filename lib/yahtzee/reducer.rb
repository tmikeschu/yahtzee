require "yahtzee/roller"
require "yahtzee/utils"
require "yahtzee/scorer"

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

      def initial_state(static = {})
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

      def start_game(state, _ = {})
        {
          status: :roll_1,
          current_hand: Roller.roll(state.fetch(:held_dice).length),
        }
      end

      def exit(state, _ = {})
        {status: :game_over}
      end

      def restart(state, _ = {})
        initial_state(state.fetch(:static))
      end

      def noop(_, _ = {})
        {}
      end

      def select_dice(state, payload = {})
        selection = payload.fetch(:parsed)
        current_hand = state.fetch(:current_hand)

        selected_count = Utils.frequencies(selection)
        current_count = Utils.frequencies(current_hand)

        status = state.fetch(:status)

        if valid_selection?(selected_count, current_count)
          state.fetch(:held_dice)
            .concat(selection)
            .then { |held_dice|
            {
              held_dice: held_dice,
              status: next_roll(status),
              error: nil,
            }.merge(status == :roll_3 ? {} : {current_hand: Roller.roll(state.fetch(:held_dice).length)})
          }
        else
          {
            error: "Invalid selection: #{selection}",
          }
        end
      end

      def select_hand(state, payload)
        selection = payload.fetch(:parsed).to_sym
        hands = state.fetch(:hands)
        hand = hands.fetch(selection, false)

        if hand == false
          {
            error: "Invalid selection: #{payload.fetch(:message)}",
          }
        elsif hand
          {
            error: "#{selection} already played. Please pick an unplayed hand.",
          }
        else
          hands, dice = state.values_at(:hands, :held_dice)
          {
            held_dice: [],
            hands: hands.merge(selection => Scorer.score(dice: dice, hand: selection)),
            current_hand: Roller.roll(0),
            status: next_roll(state.fetch(:status)),
            error: nil,
          }
        end
      end

      private

      def next_roll(status)
        {
          roll_1: :roll_2,
          roll_2: :roll_3,
          roll_3: :play_hand,
          play_hand: :roll_1,
        }.fetch(status, :noop)
      end

      def valid_selection?(selected, current)
        selected.all? { |(k, v)| current.key?(k) && v <= current.fetch(k) }
      end
    end
  end
end
