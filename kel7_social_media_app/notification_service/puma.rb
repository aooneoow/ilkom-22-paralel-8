# Port dan environment
port ENV.fetch("PORT") { 9294 }
environment ENV.fetch("RACK_ENV") { "development" }

# Gunakan hanya threads (tanpa workers)
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
threads threads_count, threads_count

# Preload aplikasi jika memungkinkan
preload_app!

on_worker_boot do
  # Reconnect ActiveRecord jika menggunakan worker (abaikan jika workers dinonaktifkan)
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
