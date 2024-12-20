threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

# Hapus konfigurasi `workers`, gunakan thread saja
port ENV.fetch("PORT") { 9293 }
preload_app!

on_worker_boot do
  require_relative './app/config/database'
end
