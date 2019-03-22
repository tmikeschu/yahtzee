require "minitest/autorun"
require "yahtzee/store"

class Yahtzee::StoreTest < Minitest::Test
  def test_it_initializes_with_arbitrary_static_data
    store = Yahtzee::Store.new({username: "tmikeschu", birthday: "1/2/1992"})

    actual = store.get_state(:static, :username)
    expected = "tmikeschu"
    assert_equal actual, expected

    actual = store.get_state(:static, :birthday)
    expected = "1/2/1992"
    assert_equal actual, expected
  end

  def test_get_state_can_take_a_path_of_keys_or_not
    store = Yahtzee::Store.new

    actual = store.get_state
    expected = Hash
    assert_equal actual.class, expected

    actual = store.get_state(:hands, :ones)
    assert_nil actual

    actual = store.get_state(:held_dice)
    expected = []
    assert_equal actual, expected
  end

  def test_state_cannot_be_changed
    store = Yahtzee::Store.new
    assert_raises NoMethodError do
      store.state[:rolls] = 1
    end
  end

  def test_total_score_returns_0_initially
    store = Yahtzee::Store.new
    actual = store.total_score
    expected = 0
    assert_equal actual, expected
  end

  def test_dispatch_sends_a_message_and_updates_the_state
    store = Yahtzee::Store.new
    store.dispatch(:start_game)
    actual = store.get_state.fetch(:status)
    expected = :in_progress
    assert_equal actual, expected
  end

  def test_subscribe_registers_a_proc
    store = Yahtzee::Store.new
    state = false

    store.subscribe(->() { state = !state })
    store.dispatch
    assert_equal state, true

    store.dispatch
    assert_equal state, false
  end
end
