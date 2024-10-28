require 'mysql2'

class Database
  def self.connection
    begin
      @client ||= Mysql2::Client.new(
        host: ENV['DB_HOST'] || 'localhost',
        username: ENV['DB_USERNAME'] || 'root',
        password: ENV['DB_PASSWORD'] || '',
        database: ENV['DB_NAME'] || 'notification_db'
      )
    rescue Mysql2::Error => e
      puts "Error connecting to the database: #{e.message}"
      exit
    end
  end

  def self.close_connection
    @client&.close if @client
  end

  def self.query(sql)
    connection.query(sql)
  end
end

