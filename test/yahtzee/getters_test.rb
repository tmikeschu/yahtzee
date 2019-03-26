require "minitest/autorun"
require "yahtzee/getters"

module Yahtzee
  class TestStore
    include Getters

    attr_reader :state
    def initialize(hands = {})
      @state = {hands: hands}
    end
  end

  class GettersTest < Minitest::Test
    def test_total_score_returns_0_initially
      store = TestStore.new
      actual = store.total_score
      expected = 0
      assert_equal actual, expected
    end

    def test_total_score_returns_sum_of_values
      store = TestStore.new({ones: 3, twos: 2, full_house: nil})
      actual = store.total_score
      expected = 5
      assert_equal actual, expected
    end
  end
end
