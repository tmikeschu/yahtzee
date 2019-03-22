require "yahtzee/reducer"
require "yahtzee/getters"

module Yahtzee
  class Store
    include Getters

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

    def initialize(static = {})
      @state = initial_state(static)
      @subscribers = []
    end

    def dispatch(message = :noop, payload = {})
      @state.merge!(Reducer.send(message, state, payload))

      subscribers.each do |subscriber|
        subscriber.call()
      end
    end

    def subscribe(subscriber)
      @subscribers << subscriber
    end

    def get_state(*keys)
      keys.inject(state) { |acc, el| acc.fetch(el) }
    end

    private

    attr_reader :state, :subscribers

    def initial_state(static)
      {
        static: static,
        hands: HANDS.reduce({}) { |acc, el| acc.merge(el => nil) },
        rolls: 0,
        current_hand: [],
        held_dice: [],
        status: :not_started,
        error: nil
      }
    end
  end
end
