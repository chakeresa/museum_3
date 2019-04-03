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
