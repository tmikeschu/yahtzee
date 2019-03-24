require "minitest/autorun"
require "yahtzee/utils"

module Yahtzee
  class UtilsTest < Minitest::Test
    def test_remove_removes_elements_in_second_array_from_first_array
      xs = [1, 2, 2, 3]
      ys = [2, 3]

      actual = Utils.remove(xs, ys)
      expected = [1, 2]

      assert_equal(actual, expected)
    end

    def test_remove_ignores_absent_elements
      xs = [1, 2, 2, 3]
      ys = [4, 3]

      actual = Utils.remove(xs, ys)
      expected = [1, 2, 2]

      assert_equal(actual, expected)
    end

    def test_remove_ignores_greater_remove_quantity
      xs = [1, 2, 2, 3]
      ys = [2, 2, 2]

      actual = Utils.remove(xs, ys)
      expected = [1, 3]

      assert_equal(actual, expected)
    end

    def test_frequencies_returns_the_elements_pointing_to_their_quantities
      xs = [1, 2, 2, 3]

      actual = Utils.frequencies(xs)
      expected = {1 => 1, 2 => 2, 3 => 1}

      assert_equal(actual, expected)
    end
  end
end
