class CommentAPI {
    static async getComments(postId) {
        try {
            const response = await fetch(`${API_CONFIG.BASE_URL}${API_CONFIG.ENDPOINTS.COMMENTS}?post_id=${postId}`);
            const data = await response.json();
            return data.data || [];
        } catch (error) {
            console.error('Error fetching comments:', error);
            return [];
        }
    }

    static async createComment(postId, content, userId) {
        try {
            const response = await fetch(`${API_CONFIG.BASE_URL}${API_CONFIG.ENDPOINTS.COMMENTS}`, {
                method: 'POST',
                headers: API_CONFIG.HEADERS,
                body: JSON.stringify({
                    post_id: postId,
                    content,
                    user_id: userId
                })
            });
            return await response.json();
        } catch (error) {
            console.error('Error creating comment:', error);
            throw error;
        }
    }

    static async deleteComment(commentId) {
        try {
            const response = await fetch(`${API_CONFIG.BASE_URL}${API_CONFIG.ENDPOINTS.COMMENTS}/${commentId}`, {
                method: 'DELETE',
                headers: API_CONFIG.HEADERS
            });
            return await response.json();
        } catch (error) {
            console.error('Error deleting comment:', error);
            throw error;
        }
    }
}