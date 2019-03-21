require "minitest/autorun"
require "yahtzee/store"

class Yahtzee::StoreTest < Minitest::Test
  def test_it_initializes_with_arbitrary_static_data
    store = Yahtzee::Store.new({username: "tmikeschu", birthday: "1/2/1992"})

    actual = store.state.dig(:static, :username)
    expected = "tmikeschu"
    assert_equal actual, expected

    actual = store.state.dig(:static, :birthday)
    expected = "1/2/1992"
    assert_equal actual, expected
  end

  def test_total_score_returns_0_initially
    store = Yahtzee::Store.new
    actual = store.total_score
    expected = 0
    assert_equal actual, expected
  end
end
