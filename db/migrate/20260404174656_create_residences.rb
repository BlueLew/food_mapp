class CreateResidences < ActiveRecord::Migration[8.1]
  def up
    create_table :residences do |t|
      t.references :user, null: false, foreign_key: true, type: reference_type_for(:users)
      t.string :city, null: false
      t.string :state
      t.string :country, null: false
      t.float :latitude
      t.float :longitude

      t.timestamps
    end unless table_exists?(:residences)

    backfill_residences_from_legacy_locations! if table_exists?(:locations) && table_exists?(:user_locations)
  end

  def down
    drop_table :residences, if_exists: true
  end

  private
    def backfill_residences_from_legacy_locations!
      execute <<~SQL.squish
        INSERT INTO residences (user_id, city, state, country, latitude, longitude, created_at, updated_at)
        SELECT
          user_locations.user_id,
          COALESCE(locations.city, ''),
          locations.state,
          COALESCE(locations.country, ''),
          locations.latitude,
          locations.longitude,
          COALESCE(user_locations.created_at, locations.created_at, CURRENT_TIMESTAMP),
          COALESCE(user_locations.updated_at, locations.updated_at, CURRENT_TIMESTAMP)
        FROM user_locations
        INNER JOIN users ON users.id = user_locations.user_id
        INNER JOIN locations ON locations.id = user_locations.location_id
        LEFT JOIN residences
          ON residences.user_id = user_locations.user_id
         AND residences.city = COALESCE(locations.city, '')
         AND COALESCE(residences.state, '') = COALESCE(locations.state, '')
         AND residences.country = COALESCE(locations.country, '')
        WHERE residences.id IS NULL
      SQL
    end

    def reference_type_for(table_name, fallback: :bigint)
      return fallback unless table_exists?(table_name)

      primary_key = connection.primary_key(table_name)
      connection.columns(table_name).find { |column| column.name == primary_key }&.type || fallback
    end
end
