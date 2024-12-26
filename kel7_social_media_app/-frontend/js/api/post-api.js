class PostAPI {
    static async getPosts() {
        try {
            const response = await fetch(`${API_CONFIG.BASE_URL}${API_CONFIG.ENDPOINTS.POSTS}`);
            const data = await response.json();
            return data.data || [];
        } catch (error) {
            console.error('Error fetching posts:', error);
            return [];
        }
    }

    static async createPost(content, userId) {
        try {
            console.log('Sending post data:', { content, user_id: userId }); // Debug log
            const response = await fetch(`${API_CONFIG.BASE_URL}${API_CONFIG.ENDPOINTS.POSTS}`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify({
                    content: content,
                    user_id: userId
                })
            });
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            const data = await response.json();
            console.log('Response:', data); // Debug log
            return data;
        } catch (error) {
            console.error('Detailed error:', error); // Debug log
            throw error;
        }
    }
    
    static async deletePost(postId) {
        try {
            const response = await fetch(`${API_CONFIG.BASE_URL}${API_CONFIG.ENDPOINTS.POSTS}/${postId}`, {
                method: 'DELETE',
                headers: API_CONFIG.HEADERS
            });
            return await response.json();
        } catch (error) {
            console.error('Error deleting post:', error);
            throw error;
        }
    }
}