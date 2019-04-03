require './lib/patron'
require './lib/exhibit'

class Museum
  attr_reader :name,
              :exhibits,
              :patrons,
              :revenue

  def initialize(name)
    @name = name
    @exhibits = []
    @patrons = []
    @revenue = 0
    @patrons_of_exhibits = {}
  end

  def add_exhibit(exhibit)
    @exhibits << exhibit
  end

  def recommend_exhibits(patron)
    @exhibits.find_all do |exhibit|
      patron.interests.include?(exhibit.name)
    end
  end

  def admit(patron)
    @patrons << patron
    sorted_exhibits = recommend_exhibits(patron).sort_by do |exhibit|
      exhibit.cost
    end
    sorted_exhibits.reverse!
    sorted_exhibits.each do |exhibit|
      if patron.spending_money >= exhibit.cost
        attend(patron, exhibit)
      end
    end
  end

  def attend(patron, exhibit)
    cost = exhibit.cost
    patron.spending_money -= cost
    @revenue += cost
  end

  def patrons_by_exhibit_interest
    @exhibits.inject(Hash.new([])) do |hash, exhibit|
      interested_patrons = @patrons.find_all do |patron|
        patron.interests.include?(exhibit.name)
      end
      hash[exhibit] = interested_patrons
      hash
    end
  end
end
