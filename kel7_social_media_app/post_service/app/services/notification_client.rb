class NotificationClient
  def self.notify(user_id, message, reference_id)
    uri = URI('http://localhost:4570/notifications')
    http = Net::HTTP.new(uri.host, uri.port)
    
    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/json'
    request.body = {
      user_id: user_id,
      message: message,
      reference_id: reference_id
    }.to_json
    
    response = http.request(request)
    JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
  rescue StandardError => e
    puts "Error sending notification: #{e.message}"
    nil
  end
end