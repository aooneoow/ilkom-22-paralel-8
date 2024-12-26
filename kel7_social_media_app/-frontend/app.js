async function fetchPosts() {
  try {
    const response = await fetch('http://localhost:4567/posts');
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    const data = await response.json();
    return data.data || [];
  } catch (error) {
    console.error('Error fetching posts:', error);
    return [];
  }
}

// Create a new post
async function createPost(content, userId = 1) {
  try {
    const response = await fetch('http://localhost:4567/posts', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ content, user_id: userId }),
    });

    if (!response.ok) {
      throw new Error('Failed to create post');
    }

    return await response.json();
  } catch (error) {
    console.error('Error creating post:', error);
  }
}

async function renderPosts() {
  try {
    const posts = await fetchPosts();

    if (posts.length === 0) {
      document.getElementById('post-list').innerHTML = '<p>No posts available.</p>';
      return;
    }

    const postList = document.getElementById('post-list');
    postList.innerHTML = '';

    posts.forEach((post) => {
      const postDiv = document.createElement('div');
      postDiv.className = 'post';
      postDiv.id = `post-${post.id}`;
      postDiv.innerHTML = `
        <h3>Post ID: ${post.id}</h3>
        <p>${post.content}</p>
        <small>Posted by User ${post.user_id} at ${post.created_at}</small>
        <button onclick="renderComments(${post.id})">Show Comments</button>
        <button onclick="handleLike(${post.id})">Like</button>
      `;
      postList.appendChild(postDiv);
    });
  } catch (error) {
    console.error('Error fetching posts:', error);
    document.getElementById('post-list').innerHTML = '<p>Failed to load posts.</p>';
  }
}

async function handlePost() {
  const contentInput = document.getElementById('post-content');
  const content = contentInput.value.trim();

  if (!content) {
    alert('Post content cannot be empty!');
    return;
  }

  try {
    const response = await fetch('http://localhost:4567/posts', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ content }),
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const result = await response.json();
    alert('Post created successfully!');
    contentInput.value = '';
    renderPosts(); // Refresh posts
  } catch (error) {
    console.error('Error creating post:', error);
    alert('Failed to create post!');
  }
}

// Handle post submission
async function handlePostSubmit() {
  const contentInput = document.getElementById('post-content');
  const content = contentInput.value.trim();

  if (!content) {
    alert('Post content cannot be empty!');
    return;
  }

  const result = await createPost(content);
  if (result) {
    alert('Post created successfully!');
    contentInput.value = ''; // Clear the input field
    renderPosts(); // Refresh the post list
  }
}

// Delete a notification
async function deleteNotification(notificationId) {
  try {
    const response = await fetch(`http://localhost:4570/notifications/${notificationId}`, {
      method: 'DELETE',
    });
    if (response.ok) {
      return await response.json();
    } else {
      throw new Error('Failed to delete notification');
    }
  } catch (error) {
    console.error('Error deleting notification:', error);
  }
}

// Render notifications with delete button
async function renderNotifications() {
  const notificationList = document.getElementById('notification-list');
  notificationList.innerHTML = ''; // Clear current notifications

  try {
    const notifications = await fetchNotifications();

    notifications.forEach((notif) => {
      const li = document.createElement('li');
      li.innerHTML = `
        ${notif.message} at ${notif.created_at}
        <button onclick="handleDeleteNotification(${notif.id})">Mark as Read</button>
      `;
      notificationList.appendChild(li);
    });
  } catch (error) {
    console.error('Error rendering notifications:', error);
    notificationList.innerHTML = '<p>Failed to load notifications.</p>';
  }
}

// Handle notification deletion
async function handleDeleteNotification(notificationId) {
  const result = await deleteNotification(notificationId);
  if (result) {
    alert('Notification marked as read!');
    renderNotifications(); // Refresh notifications
  }
}

// Fetch comments for a post
async function fetchComments(postId) {
  try {
    const response = await fetch(`http://localhost:4568/comments/${postId}`);
    const data = await response.json();
    return data.comments || [];
  } catch (error) {
    console.error('Error fetching comments:', error);
    return [];
  }
}

// Render comments for a specific post
async function renderComments(postId) {
  const postDiv = document.querySelector(`#post-${postId}`);
  
  // Prevent rendering multiple comment sections
  if (postDiv.querySelector('.comments')) return;

  const commentsDiv = document.createElement('div');
  commentsDiv.className = 'comments';
  commentsDiv.innerHTML = '<h4>Comments:</h4>';

  try {
    const comments = await fetchComments(postId);
    if (comments.length > 0) {
      comments.forEach((comment) => {
        const commentDiv = document.createElement('div');
        commentDiv.className = 'comment';
        commentDiv.innerHTML = `
          <p>${comment.content}</p>
          <small>Commented by User ${comment.user_id} at ${comment.created_at}</small>
        `;
        commentsDiv.appendChild(commentDiv);
      });
    } else {
      commentsDiv.innerHTML += '<p>No comments yet.</p>';
    }
  } catch (error) {
    console.error('Error rendering comments:', error);
    commentsDiv.innerHTML = '<p>Failed to load comments.</p>';
  }

  postDiv.appendChild(commentsDiv);
}

// Like a post
async function likePost(postId) {
  try {
    const response = await fetch(`http://localhost:4569/likes/${postId}`, {
      method: 'POST',
    });
    if (response.ok) {
      return await response.json();
    } else {
      throw new Error('Failed to like post');
    }
  } catch (error) {
    console.error('Error liking post:', error);
  }
}

// Handle like button click
async function handleLike(postId) {
  const result = await likePost(postId);
  if (result) {
    alert('Post liked!');
  }
}

// Render all posts
async function renderPosts() {
  const postList = document.getElementById('post-list');
  postList.innerHTML = ''; // Clear current posts

  try {
    const posts = await fetchPosts();

    posts.forEach((post) => {
      const postDiv = document.createElement('div');
      postDiv.className = 'post';
      postDiv.id = `post-${post.id}`;
      postDiv.innerHTML = `
        <h3>Post ID: ${post.id}</h3>
        <p>${post.content}</p>
        <small>Posted by User ${post.user_id} at ${post.created_at}</small>
        <button onclick="renderComments(${post.id})">Show Comments</button>
        <button onclick="handleLike(${post.id})">Like</button>
      `;
      postList.appendChild(postDiv);
    });
  } catch (error) {
    console.error('Error rendering posts:', error);
    postList.innerHTML = '<p>Failed to load posts.</p>';
  }
}

// Fetch notifications
async function fetchNotifications() {
  try {
    const response = await fetch('http://localhost:4570/notifications');
    const data = await response.json();
    return data.data || [];
  } catch (error) {
    console.error('Error fetching notifications:', error);
    return [];
  }
}

// Initial rendering
document.addEventListener('DOMContentLoaded', () => {
  renderPosts();
  renderNotifications();
});
