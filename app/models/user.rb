class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :likes
  has_many :places, through: :likes

  has_many :user_locations
  has_many :locations, through: :user_locations

  has_one_attached :avatar

  accepts_nested_attributes_for :locations, 
    reject_if: proc { |att| att['description'].blank? }
end
