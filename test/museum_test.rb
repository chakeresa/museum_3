require 'minitest/autorun'
require 'minitest/pride'
require './lib/museum'

class MuseumTest < Minitest::Test
  def setup
    @dmns = Museum.new("Denver Museum of Nature and Science")
    @gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    @dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    @mermaids = Exhibit.new("Mermaids", 20)
    @imax = Exhibit.new("IMAX", 15)
    @bob = Patron.new("Bob", 30)
    @sally = Patron.new("Sally", 20)
  end

  def test_it_exists
    assert_instance_of Museum, @dmns
  end

  def test_it_inits_with_name_and_zero_revenue
    assert_equal "Denver Museum of Nature and Science", @dmns.name
    assert_equal 0, @dmns.revenue
  end

  def test_it_inits_with_empty_arys_of_exhibits_and_patrons
    assert_equal [], @dmns.exhibits
    assert_equal [], @dmns.patrons
  end

  def test_it_inits_with_empty_hash_of_patrons_of_exhibits
    assert_equal ({}), @dmns.patrons_of_exhibits
  end

  def test_add_exhibit_adds_to_ary_of_exhibits
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    assert_equal [@gems_and_minerals, @dead_sea_scrolls, @imax], @dmns.exhibits
  end

  def test_recommend_exhibits_returns_ary_of_exhibits_matching_a_patrons_interests
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@imax)
    @bob.add_interest("Dead Sea Scrolls")
    @bob.add_interest("Gems and Minerals")
    @bob.add_interest("Mummies")
    @sally.add_interest("IMAX")

    assert_equal [@dead_sea_scrolls, @gems_and_minerals], @dmns.recommend_exhibits(@bob)
    assert_equal [@imax], @dmns.recommend_exhibits(@sally)
  end

  def test_admit_adds_to_patrons_ary
    @dmns.admit(@bob)
    @dmns.admit(@sally)

    assert_equal [@bob, @sally], @dmns.patrons
  end

  def test_admit_makes_patrons_attend_exhibits_they_are_interested_in_and_can_afford
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)
    @dmns.add_exhibit(@mermaids)
    @bob.add_interest("Dead Sea Scrolls")
    @bob.add_interest("IMAX")
    @sally.add_interest("Dead Sea Scrolls")
    @sally.add_interest("Mermaids")
    @dmns.admit(@bob)
    @dmns.admit(@sally)

    expected = {
      @dead_sea_scrolls => [@bob],
      @imax => [@bob],
      @mermaids => [@sally]
    }

    assert_equal 30 - 15 - 10, @bob.spending_money
    assert_equal 20 - 20, @sally.spending_money
    assert_equal expected, @dmns.patrons_of_exhibits
  end

  def test_attend_transfers_money_from_patron_to_museum
    @dmns.attend(@bob, @gems_and_minerals)
    @dmns.attend(@bob, @dead_sea_scrolls)

    assert_equal 30 - 0 - 10, @bob.spending_money
    assert_equal 0 + 0 + 10, @dmns.revenue
  end

  def test_patrons_by_exhibit_interest_returns_a_hash_with_exhibits_as_keys_and_ary_of_interested_patrons_as_values
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)
    @bob.add_interest("Dead Sea Scrolls")
    @bob.add_interest("Gems and Minerals")
    @sally.add_interest("Dead Sea Scrolls")
    @dmns.admit(@bob)
    @dmns.admit(@sally)

    expected = {
      @dead_sea_scrolls => [@bob, @sally],
      @gems_and_minerals => [@bob],
      @imax => []
    }
    assert_equal expected, @dmns.patrons_by_exhibit_interest
  end

  def test_full_sequence_of_museum
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    imax = Exhibit.new("IMAX", 15)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(imax)
    dmns.add_exhibit(dead_sea_scrolls)
    tj = Patron.new("TJ", 7)
    tj.add_interest("IMAX")
    tj.add_interest("Dead Sea Scrolls")
    dmns.admit(tj)

    assert_equal 7, tj.spending_money

    bob = Patron.new("Bob", 10)
    bob.add_interest("Dead Sea Scrolls")
    bob.add_interest("IMAX")
    dmns.admit(bob)

    assert_equal 0, bob.spending_money

    sally = Patron.new("Sally", 20)
    sally.add_interest("Dead Sea Scrolls")
    sally.add_interest("IMAX")
    dmns.admit(sally)

    assert_equal 5, sally.spending_money

    morgan = Patron.new("Morgan", 15)
    morgan.add_interest("Gems and Minerals")
    morgan.add_interest("Dead Sea Scrolls")
    dmns.admit(morgan)

    assert_equal 5, morgan.spending_money

    expected = {
      gems_and_minerals => [morgan], #TO DO: morgan isn't attending but should be!
      imax => [bob, sally],
      dead_sea_scrolls => [morgan]
    }

    assert_equal expected, dmns.patrons_of_exhibits
    assert_equal 35, dmns.revenue
  end
end
