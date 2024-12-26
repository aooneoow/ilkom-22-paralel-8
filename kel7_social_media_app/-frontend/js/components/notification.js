class NotificationComponent {
    constructor(notificationData) {
        this.notification = notificationData;
        this.element = this.createElement();
    }

    createElement() {
        const notificationElement = document.createElement('div');
        notificationElement.className = 'notification-item';
        
        let iconContent = '🔔'; // Default icon
        if (this.notification.type === 'like') iconContent = '❤️';
        if (this.notification.type === 'comment') iconContent = '💬';

        notificationElement.innerHTML = `
            <div class="notification-icon">${iconContent}</div>
            <div class="notification-content">
                <div class="notification-text">${this.notification.message}</div>
                <div class="notification-timestamp">${Utils.formatDate(this.notification.created_at)}</div>
            </div>
        `;

        if (!this.notification.read) {
            notificationElement.classList.add('unread');
        }

        return notificationElement;
    }

    markAsRead() {
        this.element.classList.remove('unread');
        NotificationAPI.markAsRead(this.notification.id);
    }
}