require "yahtzee/reducer"
require "yahtzee/getters"

module Yahtzee
  class Store
    include Getters

    DEFAULT_DISPATCH = {message: :noop, payload: {}}

    def initialize(static = {})
      @state = Reducer.initial_state(static)
      @history = nil
      @subscribers = []
    end

    def dispatch(data = {})
      message, payload = DEFAULT_DISPATCH
        .merge(data)
        .values_at(:message, :payload)

      @history = @state.dup
      @state.merge!(Reducer.send(message, state, payload))

      subscribers.each do |subscriber|
        subscriber.call
      end
    end

    def subscribe(subscriber)
      @subscribers << subscriber
    end

    def get_state(*keys)
      keys.inject(state) { |acc, el| acc.fetch(el) }
    end

    def last_state
      @history
    end

    private

    attr_reader :state, :subscribers
  end
end
