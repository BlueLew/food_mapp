class CreateSessions < ActiveRecord::Migration[8.1]
  def up
    return if table_exists?(:sessions)

    create_table :sessions do |t|
      t.references :user, null: false, foreign_key: true, type: reference_type_for(:users)
      t.string :ip_address
      t.string :user_agent

      t.timestamps
    end
  end

  def down
    drop_table :sessions, if_exists: true
  end

  private
    def reference_type_for(table_name, fallback: :bigint)
      return fallback unless table_exists?(table_name)

      primary_key = connection.primary_key(table_name)
      connection.columns(table_name).find { |column| column.name == primary_key }&.type || fallback
    end
end
