class PostComponent {
    constructor(postData) {
        this.post = postData;
        this.element = this.createElement();
        this.bindEvents();
    }

    createElement() {
        const postElement = document.createElement('div');
        postElement.className = 'post-card';
        postElement.innerHTML = `
            <div class="post-header">
                <div class="post-avatar"></div>
                <div class="post-user-info">
                    <div class="post-username">User ${this.post.user_id}</div>
                    <div class="post-timestamp">${Utils.formatDate(this.post.created_at)}</div>
                </div>
            </div>
            <div class="post-content">${this.post.content}</div>
            <div class="post-actions">
                <button class="action-button like-button" data-post-id="${this.post.id}">
                    <span class="like-count">${this.post.like_count || 0}</span> Likes
                </button>
                <button class="action-button comment-button" data-post-id="${this.post.id}">
                    <span class="comment-count">${this.post.comments?.length || 0}</span> Comments
                </button>
            </div>
        `;
        return postElement;
    }

    bindEvents() {
        const likeButton = this.element.querySelector('.like-button');
        const commentButton = this.element.querySelector('.comment-button');

        likeButton.addEventListener('click', async () => {
            try {
                const response = await LikeAPI.toggleLike(this.post.id, 1); // Hardcoded user_id for demo
                const likeCount = this.element.querySelector('.like-count');
                likeCount.textContent = response.data.like_count;
            } catch (error) {
                Utils.showError('Failed to like post');
            }
        });

        commentButton.addEventListener('click', () => {
            EventEmitter.emit('openComments', this.post.id);
        });
    }

    update(newData) {
        this.post = { ...this.post, ...newData };
        const newElement = this.createElement();
        this.element.replaceWith(newElement);
        this.element = newElement;
        this.bindEvents();
    }
}