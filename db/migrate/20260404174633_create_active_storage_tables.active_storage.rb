# This migration comes from active_storage (originally 20170806125915)
class CreateActiveStorageTables < ActiveRecord::Migration[7.0]
  def up
    # Use Active Record's configured type for primary and foreign keys
    primary_key_type, foreign_key_type = primary_and_foreign_key_types
    record_reference_type = reference_type_for(:users, fallback: foreign_key_type)
    blob_reference_type = reference_type_for(:active_storage_blobs, fallback: foreign_key_type)

    ensure_blobs_table!(primary_key_type)
    ensure_attachments_table!(primary_key_type, record_reference_type, blob_reference_type)
    ensure_variant_records_table!(primary_key_type, blob_reference_type)
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "active storage migration adapts legacy schemas in place"
  end

  private
    def ensure_blobs_table!(primary_key_type)
      unless table_exists?(:active_storage_blobs)
        create_table :active_storage_blobs, id: primary_key_type do |t|
          t.string   :key,          null: false
          t.string   :filename,     null: false
          t.string   :content_type
          t.text     :metadata
          t.string   :service_name, null: false
          t.bigint   :byte_size,    null: false
          t.string   :checksum

          if connection.supports_datetime_with_precision?
            t.datetime :created_at, precision: 6, null: false
          else
            t.datetime :created_at, null: false
          end

          t.index [ :key ], unique: true
        end
      end

      unless column_exists?(:active_storage_blobs, :service_name)
        add_column :active_storage_blobs, :service_name, :string, default: configured_service_name
      end

      execute <<~SQL.squish
        UPDATE active_storage_blobs
        SET service_name = #{connection.quote(configured_service_name)}
        WHERE service_name IS NULL OR service_name = ''
      SQL

      change_column_null :active_storage_blobs, :service_name, false
      change_column_default :active_storage_blobs, :service_name, nil
      add_index :active_storage_blobs, :key, unique: true unless index_exists?(:active_storage_blobs, :key, unique: true)
    end

    def ensure_attachments_table!(primary_key_type, record_reference_type, blob_reference_type)
      unless table_exists?(:active_storage_attachments)
        create_table :active_storage_attachments, id: primary_key_type do |t|
          t.string     :name,     null: false
          t.references :record,   null: false, polymorphic: true, index: false, type: record_reference_type
          t.references :blob,     null: false, type: blob_reference_type

          if connection.supports_datetime_with_precision?
            t.datetime :created_at, precision: 6, null: false
          else
            t.datetime :created_at, null: false
          end

          t.index [ :record_type, :record_id, :name, :blob_id ], name: :index_active_storage_attachments_uniqueness, unique: true
          t.foreign_key :active_storage_blobs, column: :blob_id
        end
      end

      add_index :active_storage_attachments, :blob_id unless index_exists?(:active_storage_attachments, :blob_id)
      unless index_exists?(:active_storage_attachments, [ :record_type, :record_id, :name, :blob_id ], name: :index_active_storage_attachments_uniqueness, unique: true)
        add_index :active_storage_attachments, [ :record_type, :record_id, :name, :blob_id ], name: :index_active_storage_attachments_uniqueness, unique: true
      end
      unless foreign_key_exists?(:active_storage_attachments, :active_storage_blobs, column: :blob_id)
        add_foreign_key :active_storage_attachments, :active_storage_blobs, column: :blob_id
      end
    end

    def ensure_variant_records_table!(primary_key_type, blob_reference_type)
      unless table_exists?(:active_storage_variant_records)
        create_table :active_storage_variant_records, id: primary_key_type do |t|
          t.belongs_to :blob, null: false, index: false, type: blob_reference_type
          t.string :variation_digest, null: false

          t.index [ :blob_id, :variation_digest ], name: :index_active_storage_variant_records_uniqueness, unique: true
          t.foreign_key :active_storage_blobs, column: :blob_id
        end
      end

      unless index_exists?(:active_storage_variant_records, [ :blob_id, :variation_digest ], name: :index_active_storage_variant_records_uniqueness, unique: true)
        add_index :active_storage_variant_records, [ :blob_id, :variation_digest ], name: :index_active_storage_variant_records_uniqueness, unique: true
      end
      unless foreign_key_exists?(:active_storage_variant_records, :active_storage_blobs, column: :blob_id)
        add_foreign_key :active_storage_variant_records, :active_storage_blobs, column: :blob_id
      end
    end

    def configured_service_name
      Rails.application.config.active_storage.service.to_s.presence || "local"
    end

    def reference_type_for(table_name, fallback:)
      return fallback unless table_exists?(table_name)

      primary_key = connection.primary_key(table_name)
      connection.columns(table_name).find { |column| column.name == primary_key }&.type || fallback
    end

    def primary_and_foreign_key_types
      config = Rails.configuration.generators
      setting = config.options[config.orm][:primary_key_type]
      primary_key_type = setting || :primary_key
      foreign_key_type = setting || :bigint
      [ primary_key_type, foreign_key_type ]
    end
end
