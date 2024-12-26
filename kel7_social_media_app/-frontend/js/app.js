class App {
    constructor() {
        this.currentUser = { id: 1 }; // Hardcoded for demo
        this.initializeElements();
        this.bindEvents();
        this.initialize();
    }

    initializeElements() {
        // Navigation buttons
        this.homeBtn = document.getElementById('homeBtn');
        this.notifBtn = document.getElementById('notifBtn');
        this.profileBtn = document.getElementById('profileBtn');

        // Content sections
        this.postsFeed = document.getElementById('postsFeed');
        this.notificationsPanel = document.getElementById('notificationsPanel');
        
        // Post creation
        this.postContent = document.getElementById('postContent');
        this.submitPost = document.getElementById('submitPost');

        // Modal elements
        this.commentModal = document.getElementById('commentModal');
        this.commentContent = document.getElementById('commentContent');
        this.submitComment = document.getElementById('submitComment');
        this.commentsList = document.getElementById('commentsList');
    }

    bindEvents() {
        // Navigation
        this.homeBtn.addEventListener('click', () => this.showSection('posts'));
        this.notifBtn.addEventListener('click', () => this.showSection('notifications'));
        this.profileBtn.addEventListener('click', () => this.showSection('profile'));

        // Post creation
        this.submitPost.addEventListener('click', () => this.createPost());

        // Comment modal
        this.commentModal.querySelector('.close-modal').addEventListener('click', 
            () => this.closeCommentModal());
        this.submitComment.addEventListener('click', () => this.submitNewComment());

        // Custom events
        EventEmitter.on('openComments', (postId) => this.openCommentModal(postId));
    }

    async initialize() {
        await this.loadPosts();
        await this.loadNotifications();
        this.showSection('posts');
    }

    async loadPosts() {
        const posts = await PostAPI.getPosts();
        this.postsFeed.innerHTML = '';
        posts.forEach(post => {
            const postComponent = new PostComponent(post);
            this.postsFeed.appendChild(postComponent.element);
        });
    }

    async loadNotifications() {
        const notifications = await NotificationAPI.getNotifications(this.currentUser.id);
        const notificationsList = document.getElementById('notificationsList');
        notificationsList.innerHTML = '';
        notifications.forEach(notification => {
            const notificationComponent = new NotificationComponent(notification);
            notificationsList.appendChild(notificationComponent.element);
        });
    }

    showSection(section) {
        // Hide all sections
        this.postsFeed.classList.add('hidden');
        this.notificationsPanel.classList.add('hidden');

        // Show selected section
        switch(section) {
            case 'posts':
                this.postsFeed.classList.remove('hidden');
                break;
            case 'notifications':
                this.notificationsPanel.classList.remove('hidden');
                break;
            case 'profile':
                // Implement profile view
                break;
        }
    }

    async createPost() {
        const content = this.postContent.value.trim();
        if (!content) return;

        try {
            await PostAPI.createPost(content, this.currentUser.id);
            this.postContent.value = '';
            await this.loadPosts();
            Utils.showSuccess('Post created successfully!');
        } catch (error) {
            Utils.showError('Failed to create post');
        }
    }

    async openCommentModal(postId) {
        this.commentModal.classList.remove('hidden');
        this.commentModal.dataset.postId = postId;
        
        // Load comments
        const comments = await CommentAPI.getComments(postId);
        this.commentsList.innerHTML = '';
        comments.forEach(comment => {
            const commentElement = document.createElement('div');
            commentElement.className = 'comment-card';
            commentElement.innerHTML = `
                <div class="comment-header">
                    <div class="comment-avatar"></div>
                    <div class="comment-user-info">
                        <div class="comment-username">User ${comment.user_id}</div>
                        <div class="comment-timestamp">${Utils.formatDate(comment.created_at)}</div>
                    </div>
                </div>
                <div class="comment-content">${comment.content}</div>
            `;
            this.commentsList.appendChild(commentElement);
        });
    }

    closeCommentModal() {
        this.commentModal.classList.add('hidden');
        this.commentContent.value = '';
    }

    async submitNewComment() {
        const content = this.commentContent.value.trim();
        const postId = this.commentModal.dataset.postId;
        
        if (!content) return;

        try {
            await CommentAPI.createComment(postId, content, this.currentUser.id);
            await this.openCommentModal(postId); // Reload comments
            this.commentContent.value = '';
            Utils.showSuccess('Comment added successfully!');
        } catch (error) {
            Utils.showError('Failed to add comment');
        }
    }
}

// Initialize app when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    new App();
});