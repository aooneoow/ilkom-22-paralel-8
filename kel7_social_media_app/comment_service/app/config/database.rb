require 'active_record'

# Konfigurasi koneksi database SQLite3
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/comment_service.db'
)

# Membuat tabel jika belum ada
unless ActiveRecord::Base.connection.table_exists?(:comments)
  ActiveRecord::Schema.define do
    create_table :comments do |t|
      t.string :content
      t.integer :post_id
      t.integer :user_id
      t.timestamps
    end
  end
end
