require "minitest/autorun"
require "yahtzee/scorer"

module Yahtzee
  class ScorerTest < Minitest::Test
    def test_score_adds_ones
      actual = Scorer.score(
        dice: [1, 2, 3, 4, 1],
        hand: :ones,
      )
      expected = 2
      assert_equal(actual, expected)
    end

    def test_score_adds_twos
      actual = Scorer.score(
        dice: [1, 2, 3, 4, 2],
        hand: :twos,
      )
      expected = 4
      assert_equal(actual, expected)
    end

    def test_score_adds_threes
      actual = Scorer.score(
        dice: [1, 2, 3, 3, 3],
        hand: :threes,
      )
      expected = 9
      assert_equal(actual, expected)
    end

    def test_score_adds_fours
      actual = Scorer.score(
        dice: [1, 2, 4, 4, 1],
        hand: :fours,
      )
      expected = 8
      assert_equal(actual, expected)
    end

    def test_score_adds_fives
      actual = Scorer.score(
        dice: [1, 5, 5, 5, 5],
        hand: :fives,
      )
      expected = 20
      assert_equal(actual, expected)
    end

    def test_score_adds_sixes
      actual = Scorer.score(
        dice: [6, 5, 6, 6, 1],
        hand: :sixes,
      )
      expected = 18
      assert_equal(actual, expected)
    end

    def test_score_adds_no_points_correctly
      actual = Scorer.score(
        dice: [6, 5, 6, 6, 1],
        hand: :twos,
      )
      expected = 0
      assert_equal(actual, expected)
    end

    def test_score_adds_small_straight
      actual = Scorer.score(
        dice: [1, 2, 3, 4, 6],
        hand: :small_straight,
      )
      expected = 30
      assert_equal(actual, expected)
    end

    def test_score_adds_0_for_bad_small_straight
      actual = Scorer.score(
        dice: [1, 2, 3, 5, 6],
        hand: :small_straight,
      )
      expected = 0
      assert_equal(actual, expected)
    end

    def test_score_adds_large_straight
      actual = Scorer.score(
        dice: [1, 2, 3, 4, 5],
        hand: :large_straight,
      )
      expected = 40
      assert_equal(actual, expected)
    end

    def test_score_adds_0_for_bad_large_straight
      actual = Scorer.score(
        dice: [1, 2, 3, 5, 6],
        hand: :large_straight,
      )
      expected = 0
      assert_equal(actual, expected)
    end

    def test_score_adds_chance
      actual = Scorer.score(
        dice: [1, 2, 3, 4, 5],
        hand: :chance,
      )
      expected = 15
      assert_equal(actual, expected)
    end

    def test_score_adds_yahtzee
      actual = Scorer.score(
        dice: [1, 1, 1, 1, 1],
        hand: :yahtzee,
      )
      expected = 50
      assert_equal(actual, expected)
    end

    def test_score_adds_0_for_bad_yahtzee
      actual = Scorer.score(
        dice: [1, 2, 3, 4, 5],
        hand: :yahtzee,
      )
      expected = 0
      assert_equal(actual, expected)
    end

    def test_score_adds_full_house
      actual = Scorer.score(
        dice: [1, 1, 1, 2, 2],
        hand: :full_house,
      )
      expected = 25
      assert_equal(actual, expected)
    end

    def test_score_adds_0_for_bad_full_house
      actual = Scorer.score(
        dice: [1, 1, 2, 2, 3],
        hand: :full_house,
      )
      expected = 0
      assert_equal(actual, expected)
    end

    def test_score_yahtzee_is_a_valid_full_house
      actual = Scorer.score(
        dice: Array.new(5) { 1 },
        hand: :full_house,
      )
      expected = 25
      assert_equal(actual, expected)
    end

    def test_score_yahtzee_is_a_valid_large_straight
      actual = Scorer.score(
        dice: Array.new(5) { 1 },
        hand: :large_straight,
      )
      expected = 40
      assert_equal(actual, expected)
    end

    def test_score_yahtzee_is_a_valid_small_straight
      actual = Scorer.score(
        dice: Array.new(5) { 1 },
        hand: :small_straight,
      )
      expected = 30
      assert_equal(actual, expected)
    end
  end
end
