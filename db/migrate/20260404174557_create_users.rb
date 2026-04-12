class CreateUsers < ActiveRecord::Migration[8.1]
  def up
    table_exists?(:users) ? migrate_existing_users_table! : create_users_table!
    ensure_email_address_index!
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "users migration adapts legacy schemas in place"
  end

  private
    def create_users_table!
      create_table :users do |t|
        t.string :email_address, null: false
        t.string :password_digest, null: false

        t.timestamps
      end
    end

    def migrate_existing_users_table!
      rename_or_copy_column(:users, from: :email, to: :email_address)
      rename_or_copy_column(:users, from: :encrypted_password, to: :password_digest)

      normalize_email_addresses!

      change_column_null :users, :email_address, false if column_exists?(:users, :email_address)
      change_column_null :users, :password_digest, false if column_exists?(:users, :password_digest)
    end

    def rename_or_copy_column(table_name, from:, to:)
      return unless column_exists?(table_name, from)

      if column_exists?(table_name, to)
        execute <<~SQL.squish
          UPDATE #{connection.quote_table_name(table_name)}
          SET #{connection.quote_column_name(to)} = #{connection.quote_column_name(from)}
          WHERE #{connection.quote_column_name(to)} IS NULL
            AND #{connection.quote_column_name(from)} IS NOT NULL
        SQL
      else
        rename_column table_name, from, to
      end
    end

    def normalize_email_addresses!
      return unless column_exists?(:users, :email_address)

      execute <<~SQL.squish
        UPDATE users
        SET email_address = LOWER(BTRIM(email_address))
        WHERE email_address IS NOT NULL
      SQL
    end

    def ensure_email_address_index!
      if index_name_exists?(:users, "index_users_on_email") &&
         !index_name_exists?(:users, "index_users_on_email_address")
        rename_index :users, "index_users_on_email", "index_users_on_email_address"
      end

      add_index :users, :email_address, unique: true unless index_exists?(:users, :email_address, unique: true)
    end
end
