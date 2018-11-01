class Place < ApplicationRecord
  geocoded_by :address
  after_validation :geocode, if: :address_changed?
  
  has_many :likes
  has_many :users, through: :likes

  has_one_attached :photo
end
