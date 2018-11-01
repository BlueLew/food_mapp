class ChangeLatLongNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :places, :latitude, true
    change_column_null :places, :longitude, true
  end
end
