require "minitest/autorun"
require "yahtzee/response_parser"

module Yahtzee
  class ResponseParserTest < Minitest::Test
    def test_digits_extracts_digits_from_input_string
      raw = "1 2, 3:4"
      actual = ResponseParser.digits.call(raw)
      expected = [1, 2, 3, 4]
      assert_equal(actual, expected)
    end
  end
end
