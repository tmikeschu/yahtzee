module Yahtzee
  module Scorer
    count = ->(n, xs) { xs.select { |x| x == n }.sum }.curry(2)
    of_a_kind = ->(n, xs) {
      xs.reduce({}) { |acc, el| acc.merge(el => 1) { |a| a + 1 } }.
        select {|_, v| v >= n }.
        reduce(0) { |_, k, v| k * v }
    }.curry(2)

    is_ascending = ->((a, b)) { b - a == 1 }
    is_consecutive = ->(xs) { xs.sort.each_cons(2).all?(&is_ascending) }

    is_yahtzee = ->(xs) { xs.uniq.length == 1 }
    HANDS = {
      ones: count.call(1),
      twos: count.call(2),
      threes: count.call(3),
      fours: count.call(4),
      fives: count.call(5),
      sixes: count.call(6),
      three_of_a_kind: of_a_kind.call(3),
      four_of_a_kind: of_a_kind.call(4),
      full_house: ->(dice) {
        if dice.group_by(&:itself).values.map(&:length).sort == [2, 3] || is_yahtzee.call(dice)
          25
        else
          0
        end
      },
      small_straight: ->(dice) {
        if dice.sort.each_cons(4).any?(&is_consecutive) || is_yahtzee.call(dice)
          30
        else
          0
        end
      },
      large_straight: ->(dice) {
        if is_consecutive.call(dice) || is_yahtzee.call(dice)
          40
        else
          0
        end
      },
      yahtzee: ->(dice) {is_yahtzee.call(dice) ? 50 : 0},
      chance: ->(dice) {dice.sum},
    }
    SCORE_INIT = HANDS.reduce({}) { |acc, (hand, *_)| acc.merge(hand => 0) }

    def self.score(dice:, hand:, current_score:)
      current_score.merge({
        hand => HANDS.fetch(hand, ->(_) { 0 }).call(dice).to_i,
      })
    end
  end
end
