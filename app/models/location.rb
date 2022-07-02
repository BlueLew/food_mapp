class Location < ApplicationRecord
  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  def address
    [city, state, country].compact.join(', ')
  end

  def address_changed?
    city_changed? || state_changed? || country_changed?
  end

  has_many :user_locations
  has_many :users, through: :user_locations
end
