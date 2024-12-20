class NotificationService
  # Fungsi untuk membuat dan menyimpan notifikasi
  def self.create_notification(user_id, message)
    Notification.create(user_id: user_id, message: message)
  end

  # Fungsi untuk mengirim notifikasi (dummy, bisa diperluas)
  def self.send_notification(user_id, message)
    # Logika pengiriman notifikasi, seperti via email atau push notification
    puts "Sending notification to User #{user_id}: #{message}"
  end
end
