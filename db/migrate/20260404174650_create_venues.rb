class CreateVenues < ActiveRecord::Migration[8.1]
  def change
    create_table :venues do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.string :category, null: false
      t.string :phone
      t.string :website
      t.float :latitude
      t.float :longitude

      t.timestamps
    end

    add_index :venues, :name
  end
end
