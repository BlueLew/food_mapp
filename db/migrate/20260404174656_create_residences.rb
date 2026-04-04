class CreateResidences < ActiveRecord::Migration[8.1]
  def change
    create_table :residences do |t|
      t.references :user, null: false, foreign_key: true
      t.string :city, null: false
      t.string :state
      t.string :country, null: false
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
