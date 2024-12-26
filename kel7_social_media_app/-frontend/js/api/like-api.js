class LikeAPI {
    static async getLikes(postId) {
        try {
            const response = await fetch(`${API_CONFIG.BASE_URL}${API_CONFIG.ENDPOINTS.LIKES}?post_id=${postId}`);
            const data = await response.json();
            return data.data || [];
        } catch (error) {
            console.error('Error fetching likes:', error);
            return [];
        }
    }

    static async toggleLike(postId, userId) {
        try {
            const response = await fetch(`${API_CONFIG.BASE_URL}${API_CONFIG.ENDPOINTS.LIKES}/toggle`, {
                method: 'POST',
                headers: API_CONFIG.HEADERS,
                body: JSON.stringify({
                    post_id: postId,
                    user_id: userId
                })
            });
            return await response.json();
        } catch (error) {
            console.error('Error toggling like:', error);
            throw error;
        }
    }
}