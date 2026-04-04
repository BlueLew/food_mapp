class Venue < ApplicationRecord
  include PgSearch::Model

  geocoded_by :address
  after_validation :geocode, if: :should_geocode?

  has_many :likes, dependent: :destroy
  has_many :users, through: :likes
  has_one_attached :photo

  validates :name, :address, :category, presence: true

  pg_search_scope :search_text,
    against: {
      name: "A",
      category: "B",
      address: "B"
    },
    using: {
      tsearch: {
        prefix: true
      }
    }

  scope :ordered, -> { order(:name) }

  def self.search_for(query)
    query.present? ? search_text(query).ordered : ordered
  end

  def liked_residences
    Residence
      .joins(user: :likes)
      .where(likes: { venue_id: id })
      .includes(:user)
      .order(created_at: :desc)
  end

  def likes_by(attribute)
    liked_residences
      .reorder(nil)
      .where.not(attribute => [ nil, "" ])
      .group(attribute)
      .count
      .map { |name, likes| { name:, likes: } }
      .sort_by { |group| [ -group[:likes], group[:name] ] }
  end

  private
    def should_geocode?
      !Rails.env.test? && ENV["GOOGLE_MAPS_API_KEY"].present? && will_save_change_to_address? && address.present?
    end
end
