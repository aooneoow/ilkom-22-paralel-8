require 'mysql2'
require 'dotenv/load'

class Database
  class << self
    def connection
      @connection ||= Mysql2::Client.new(
        host: ENV['DB_HOST'],
        username: ENV['DB_USER'],
        password: ENV['DB_PASSWORD'],
        database: ENV['DB_NAME']
      )
    end

    def query(sql, params = [])
      begin
        if params.empty?
          connection.query(sql)
        else
          statement = connection.prepare(sql)
          statement.execute(*params)
        end
      rescue Mysql2::Error => e
        puts "Database error: #{e.message}"
        raise e
      end
    end

    def last_insert_id
      connection.last_id
    end


    def close_connection
      @connection.close if @connection
      @connection = nil
    end

    def all(table)
      query("SELECT * FROM #{table}")
    end

    def find(table, id)
      query("SELECT * FROM #{table} WHERE id = ?", [id]).first
    end


    def insert(table, attributes)
      columns = attributes.keys.join(", ")
      placeholders = attributes.keys.map { '?' }.join(", ")
      query("INSERT INTO #{table} (#{columns}) VALUES (#{placeholders})", attributes.values)
      last_insert_id
    end

    def update(table, id, attributes)
      set_clause = attributes.map { |key| "#{key} = ?" }.join(", ")
      query("UPDATE #{table} SET #{set_clause} WHERE id = ?", attributes.values + [id])
    end

    def delete(table, id)
      query("DELETE FROM #{table} WHERE id = ?", [id])
    end
  end
end