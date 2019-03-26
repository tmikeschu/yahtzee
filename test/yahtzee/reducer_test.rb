require "minitest/autorun"
require "yahtzee/reducer"

module Yahtzee
  class ReducerTest < Minitest::Test
    def test_start_game_changes_the_status_and_current_hand
      before = Reducer.initial_state
      after = Reducer.start_game(before)
      assert_equal(after.fetch(:status), :roll_1)
      refute_equal(after.fetch(:current_hand), before.fetch(:current_hand))
    end

    def test_exit_sets_status_to_game_over
      before = Reducer.initial_state
      after = Reducer.exit(before)
      assert_equal(after.fetch(:status), :game_over)
    end

    def test_restart_sets_state_back_to_initial_including_config
      before = Reducer.initial_state({username: "Hermione"}).merge(rolls: 3)
      after = Reducer.restart(before)
      assert_equal(after.fetch(:rolls), 0)
      assert_equal(after.dig(:static, :username), "Hermione")
    end

    def test_noop_does_nothing
      actual = Reducer.noop(Reducer.initial_state)
      expected = {}
      assert_equal(actual, expected)
    end

    def test_select_dice_holds_selected_dice
      state = Reducer.initial_state.merge(
        current_hand: [1, 1, 2, 5, 6],
        status: :roll_1,
      )
      actual = Reducer.select_dice(state, {parsed: [1, 1]}).values_at(:held_dice, :status)
      expected = [[1, 1], :roll_2]
      assert_equal(actual, expected)
    end

    def test_select_dice_rejects_invalid_attempts
      state = Reducer.initial_state.merge(
        current_hand: [1, 1, 2, 5, 6],
        status: :roll_1,
      )
      actual = Reducer.select_dice(state, {parsed: [1, 1, 1]}).fetch(:error)
      expected = "Invalid selection: [1, 1, 1]"
      assert_equal(actual, expected)

      actual = Reducer.select_dice(state, {parsed: [7]}).fetch(:error)
      expected = "Invalid selection: [7]"
      assert_equal(actual, expected)
    end

    def test_select_dice_removes_error_when_valid
      state = Reducer.initial_state.merge(
        current_hand: [1, 1, 2, 5, 6],
        status: :roll_1,
        error: "invalid",
      )
      actual = Reducer.select_dice(state, {parsed: [1, 1]}).fetch(:error)
      assert_nil(actual)
    end

    def test_select_hand_rejects_an_invalid_hand
      state = Reducer.initial_state
      actual = Reducer.select_hand(state, {message: "something else", parsed: "something else"}).fetch(:error)
      expected = "Invalid selection: something else"
      assert_equal(actual, expected)
    end

    def test_select_hand_rejects_an_already_played_hand
      state = Reducer.initial_state
      state[:hands] = state.fetch(:hands).merge(ones: 2)
      actual = Reducer.select_hand(state, {parsed: "ones"}).fetch(:error)
      expected = "ones already played. Please pick an unplayed hand."
      assert_equal(actual, expected)
    end

    def test_select_hand_calculates_a_hand
      state = Reducer.initial_state.merge(held_dice: [3, 3, 3, 2, 2], status: :play_hand)
      actual = Reducer.select_hand(state, {parsed: "full_house"})
      assert_equal(actual.fetch(:held_dice), [])
      assert_equal(actual.fetch(:hands), state.fetch(:hands).merge({full_house: 25}))
      assert_equal(actual.fetch(:status), :roll_1)
      refute_equal(actual.fetch(:current_hand), state.fetch(:current_hand))
    end

    def test_select_hand_removes_error_for_vaid_hand
      state = Reducer.initial_state.merge({held_dice: [3, 3, 3, 2, 2], error: "invalid"})
      actual = Reducer.select_hand(state, {parsed: "full_house"}).fetch(:error)
      assert_nil(actual)
    end
  end
end
