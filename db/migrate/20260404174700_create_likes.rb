class CreateLikes < ActiveRecord::Migration[8.1]
  def up
    if table_exists?(:likes)
      rename_column :likes, :place_id, :venue_id if column_exists?(:likes, :place_id) && !column_exists?(:likes, :venue_id)
    else
      create_table :likes do |t|
        t.references :user, null: false, foreign_key: true, type: reference_type_for(:users)
        t.references :venue, null: false, foreign_key: true, type: reference_type_for(:venues)

        t.timestamps
      end
    end

    deduplicate_likes!
    add_index :likes, [ :user_id, :venue_id ], unique: true unless index_exists?(:likes, [ :user_id, :venue_id ], unique: true)
    add_foreign_key :likes, :users unless foreign_key_exists?(:likes, :users)
    add_foreign_key :likes, :venues, column: :venue_id unless foreign_key_exists?(:likes, :venues, column: :venue_id)
  end

  def down
    drop_table :likes, if_exists: true
  end

  private
    def deduplicate_likes!
      return unless column_exists?(:likes, :venue_id)

      execute <<~SQL.squish
        DELETE FROM likes older_like
        USING likes newer_like
        WHERE older_like.id > newer_like.id
          AND older_like.user_id = newer_like.user_id
          AND older_like.venue_id = newer_like.venue_id
      SQL
    end

    def reference_type_for(table_name, fallback: :bigint)
      return fallback unless table_exists?(table_name)

      primary_key = connection.primary_key(table_name)
      connection.columns(table_name).find { |column| column.name == primary_key }&.type || fallback
    end
end
