require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/posts_service.db',
  pool: 5, # Maksimal 5 koneksi untuk mendukung multi-threading
  timeout: 5000
)

# Jika tabel belum ada, buat tabel `posts`
unless ActiveRecord::Base.connection.table_exists?(:posts)
  ActiveRecord::Schema.define do
    create_table :posts do |t|
      t.string :content
      t.integer :user_id
      t.timestamps
    end
  end
end
