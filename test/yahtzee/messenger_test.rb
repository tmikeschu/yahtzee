require "minitest/autorun"
require "yahtzee/messenger"

module Yahtzee
  class MessengerTest < Minitest::Test
    def test_interpret_takes_a_status_and_a_payload
      actual = Messenger.interpret(:start_game, {message: "", key: :start_game})
      expected = {message: :start_game, payload: {message: "", key: :start_game}}
      assert_equal(actual, expected)
    end

    def test_interpret_recognizes_exit_as_a_global_intent
      actual = Messenger.interpret(:start_game, {message: "exit", key: :start_game})
      expected = {message: :exit}
      assert_equal(actual, expected)
    end

    def test_interpret_recognizes_restart_as_a_global_intent
      actual = Messenger.interpret(:start_game, {message: "restart", key: :start_game})
      expected = {message: :restart}
      assert_equal(actual, expected)
    end
  end
end
