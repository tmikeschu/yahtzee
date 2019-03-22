module Yahtzee
  module Getters
    def total_score
      state.
        fetch(:hands, {}).
        values.
        sum(&:to_i)
    end
  end
end
