const Utils = {
    formatDate(dateString) {
        const date = new Date(dateString);
        const now = new Date();
        const diff = (now - date) / 1000; // difference in seconds

        if (diff < 60) {
            return 'just now';
        } else if (diff < 3600) {
            const minutes = Math.floor(diff / 60);
            return `${minutes}m ago`;
        } else if (diff < 86400) {
            const hours = Math.floor(diff / 3600);
            return `${hours}h ago`;
        } else if (diff < 604800) {
            const days = Math.floor(diff / 86400);
            return `${days}d ago`;
        } else {
            return date.toLocaleDateString();
        }
    },

    truncateText(text, maxLength = 150) {
        if (text.length <= maxLength) return text;
        return text.substr(0, maxLength) + '...';
    },

    showError(message) {
        // You could implement a toast notification here
        console.error(message);
        alert(message);
    },

    showSuccess(message) {
        // You could implement a toast notification here
        console.log(message);
        alert(message);
    }
};

// Event handling utility
const EventEmitter = {
    events: {},
    
    on(eventName, callback) {
        if (!this.events[eventName]) {
            this.events[eventName] = [];
        }
        this.events[eventName].push(callback);
    },
    
    emit(eventName, data) {
        if (this.events[eventName]) {
            this.events[eventName].forEach(callback => callback(data));
        }
    }
};