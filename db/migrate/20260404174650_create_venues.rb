class CreateVenues < ActiveRecord::Migration[8.1]
  def up
    create_table :venues, id: primary_key_type_for(:places, fallback: generated_primary_key_type) do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.string :category, null: false
      t.string :phone
      t.string :website
      t.float :latitude
      t.float :longitude

      t.timestamps
    end unless table_exists?(:venues)

    add_index :venues, :name unless index_exists?(:venues, :name)
    if table_exists?(:places)
      backfill_venues_from_places!
      reset_primary_key_sequence!(:venues)
    end
  end

  def down
    drop_table :venues, if_exists: true
  end

  private
    def backfill_venues_from_places!
      execute <<~SQL.squish
        INSERT INTO venues (id, name, address, category, phone, website, latitude, longitude, created_at, updated_at)
        SELECT
          places.id,
          places.name,
          places.address,
          COALESCE(NULLIF(places.category, ''), NULLIF(places.type, ''), 'Uncategorized'),
          places.phone_number,
          places.website,
          places.latitude,
          places.longitude,
          places.created_at,
          places.updated_at
        FROM places
        LEFT JOIN venues ON venues.id = places.id
        WHERE venues.id IS NULL
      SQL
    end

    def reset_primary_key_sequence!(table_name)
      return unless connection.respond_to?(:reset_pk_sequence!)

      connection.reset_pk_sequence!(table_name)
    end

    def generated_primary_key_type
      config = Rails.configuration.generators
      config.options[config.orm][:primary_key_type] || :primary_key
    end

    def primary_key_type_for(table_name, fallback:)
      return fallback unless table_exists?(table_name)

      primary_key = connection.primary_key(table_name)
      connection.columns(table_name).find { |column| column.name == primary_key }&.type || fallback
    end
end
