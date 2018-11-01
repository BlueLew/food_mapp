class RenamePlacesColumns < ActiveRecord::Migration[5.2]
  def change
    rename_column :Places, :formatted_address, :address
    rename_column :Places, :formatted_phone_number, :phone_number
    rename_column :Places, :opening_hours, :hours
  end
end
