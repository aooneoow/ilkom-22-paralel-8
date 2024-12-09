require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/like_service.db',
  pool: 5, # Maksimal 5 koneksi untuk mendukung multi-threading
  timeout: 5000
)

# Jika tabel belum ada, buat tabel `likes`
unless ActiveRecord::Base.connection.table_exists?(:likes)
  ActiveRecord::Schema.define do
    create_table :likes do |t|
      t.integer :post_id
      t.integer :user_id
      t.timestamps
    end
  end
end
