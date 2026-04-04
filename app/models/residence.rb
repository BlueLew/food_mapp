class Residence < ApplicationRecord
  belongs_to :user

  geocoded_by :full_address
  after_validation :geocode, if: :should_geocode?

  normalizes :city, with: ->(value) { value.to_s.squish }
  normalizes :state, with: ->(value) { value.to_s.squish }
  normalizes :country, with: ->(value) { value.to_s.squish }

  validates :city, :country, presence: true

  scope :ordered, -> { order(created_at: :desc) }

  def full_address
    [ city, state, country ].reject(&:blank?).join(", ")
  end

  private
    def should_geocode?
      !Rails.env.test? &&
        ENV["GOOGLE_MAPS_API_KEY"].present? &&
        full_address.present? &&
        (will_save_change_to_city? || will_save_change_to_state? || will_save_change_to_country?)
    end
end
