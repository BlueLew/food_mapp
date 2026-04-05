class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :residences, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_venues, through: :likes, source: :venue
  has_one_attached :avatar

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  normalizes :name, with: ->(name) { name.to_s.squish }

  enum :role, { member: 0, admin: 1 }, default: :member

  validates :email_address, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true

  def display_name
    name.presence || email_address
  end
end
