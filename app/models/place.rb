class Place < ApplicationRecord
  geocoded_by :address
  after_validation :geocode, if: :address_changed?
  include PgSearch
  scope :sorted, ->{ order(name: :asc) }
  #pg_search_scope :search_by_name, :against => [:name]
  #pg_search_scope :search_by_category, :against => [:category]

  pg_search_scope :search,
                  against: [
                    :name,
                    :category
                  ],
                  using: {
                    tsearch: {
                      prefix: true,
                      normalization: 2
                    }
                  }
  
  has_many :likes
  has_many :users, through: :likes
  has_many :locations, through: :users

  has_one_attached :photo

  def self.perform_search(keyword)
    if keyword.present?
    then Place.search(keyword)
    else Place.all
    end.sorted
  end

  def locations
    users.map(&:locations).flatten
  end

  def cities
    locations.map(&:city)
  end

  def states
    locations.map(&:state)
  end

  def countries
    locations.map(&:country)
  end
end
