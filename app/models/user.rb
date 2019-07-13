class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :likes
  has_many :places, through: :likes

  has_many :user_locations
  has_many :locations, through: :user_locations

  has_one_attached :avatar

  accepts_nested_attributes_for :locations
end
