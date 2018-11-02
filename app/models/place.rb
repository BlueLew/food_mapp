class Place < ApplicationRecord
  geocoded_by :address
  after_validation :geocode, if: :address_changed?
  include PgSearch
  pg_search_scope :search_by_name, :against => [:name]
  pg_search_scope :search_by_category, :against => [:category]
  
  has_many :likes
  has_many :users, through: :likes

  has_one_attached :photo
end
