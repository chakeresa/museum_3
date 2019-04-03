require 'minitest/autorun'
require 'minitest/pride'
require './lib/patron'

class PatronTest < Minitest::Test
  def setup
    @bob = Patron.new("Bob", 20)
  end

  def test_it_exists
    assert_instance_of Patron, @bob
  end

  def test_it_inits_with_name_and_spending_money
    assert_equal "Bob", @bob.name
    assert_equal 20, @bob.spending_money
  end

  def test_it_inits_with_empty_ary_of_interests
    assert_equal [], @bob.interests
  end

  def test_add_interest_adds_to_interests_ary
    @bob.add_interest("Dead Sea Scrolls")
    @bob.add_interest("Gems and Minerals")

    assert_equal ["Dead Sea Scrolls", "Gems and Minerals"], @bob.interests
  end
end
