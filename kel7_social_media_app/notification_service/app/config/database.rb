require 'active_record'

# Konfigurasi koneksi ke database SQLite3
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/notification_service.db'
)

# Membuat tabel notifikasi jika belum ada
unless ActiveRecord::Base.connection.table_exists?(:notifications)
  ActiveRecord::Schema.define do
    create_table :notifications do |t|
      t.string :message
      t.integer :user_id
      t.boolean :read, default: false
      t.timestamps
    end
  end
end
