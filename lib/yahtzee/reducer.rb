module Yahtzee
  module Reducer
    class << self
      def start_game(state, payload)
        state.merge(status: :in_progress)
      end

      def noop(state, _)
        state
      end
    end
  end
end
