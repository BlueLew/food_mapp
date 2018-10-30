class CreatePlaces < ActiveRecord::Migration[5.2]
  def change
    create_table :places do |t|
      t.string :name, null: false
      t.string :formatted_address, null: false
      t.string :type
      t.string :formatted_phone_number
      t.string :opening_hours
      t.string :website
      t.string :price_level
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.string :google_place_id
      t.string :google_id

      t.timestamps
    end
  end
end
