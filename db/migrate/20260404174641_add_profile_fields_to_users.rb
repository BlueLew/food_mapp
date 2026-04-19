class AddProfileFieldsToUsers < ActiveRecord::Migration[8.1]
  def up
    ensure_name_column!
    ensure_role_column!
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "profile fields migration adapts legacy users in place"
  end

  private
    def ensure_name_column!
      if column_exists?(:users, :name)
        execute <<~SQL.squish
          UPDATE users
          SET name = ''
          WHERE name IS NULL
        SQL
        change_column_default :users, :name, ""
        change_column_null :users, :name, false
      else
        add_column :users, :name, :string, null: false, default: ""
      end
    end

    def ensure_role_column!
      add_column :users, :role, :integer, null: false, default: 0 unless column_exists?(:users, :role)

      if column_exists?(:users, :admin) && column_exists?(:users, :role)
        execute <<~SQL.squish
          UPDATE users
          SET role = CASE WHEN admin THEN 1 ELSE 0 END
        SQL
      end

      change_column_default :users, :role, 0
      change_column_null :users, :role, false
    end
end
