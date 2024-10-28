class PostController < ApplicationController
  # Get all posts
  get '/api/posts' do
    begin
      posts = PostService.get_all_posts(
        page: (params[:page] || 1).to_i,
        per_page: (params[:per_page] || 10).to_i
      )
      
      json({
        status: 'success',
        data: posts,
        meta: {
          page: params[:page]&.to_i || 1,
          per_page: params[:per_page]&.to_i || 10
        }
      })
    rescue => e
      status 500
      json({ status: 'error', message: e.message })
    end
  end

  # Get single post
  get '/api/posts/:id' do
    begin
      post = PostService.get_post(params[:id])
      
      if post
        json({ status: 'success', data: post })
      else
        status 404
        json({ status: 'error', message: 'Post not found' })
      end
    rescue => e
      status 500
      json({ status: 'error', message: e.message })
    end
  end

  # Create post
  post '/api/posts' do
    authenticate!
    
    begin
      # Validate required parameters
      unless json_params[:content]
        status 400
        return json({ status: 'error', message: 'Content is required' })
      end

      post = PostService.create_post(
        user_id: current_user.id,
        content: json_params[:content],
        media_urls: json_params[:media_urls] || []
      )
      
      status 201
      json({ status: 'success', data: post })
    rescue => e
      status 400
      json({ status: 'error', message: e.message })
    end
  end

  # Update post
  put '/api/posts/:id' do
    authenticate!
    
    begin
      post = PostService.update_post(
        id: params[:id],
        user_id: current_user.id,
        content: json_params[:content],
        media_urls: json_params[:media_urls]
      )
      
      if post
        json({ status: 'success', data: post })
      else
        status 404
        json({ status: 'error', message: 'Post not found or unauthorized' })
      end
    rescue => e
      status 400
      json({ status: 'error', message: e.message })
    end
  end

  # Delete post
  delete '/api/posts/:id' do
    authenticate!
    
    begin
      if PostService.delete_post(id: params[:id], user_id: current_user.id)
        status 204
      else
        status 404
        json({ status: 'error', message: 'Post not found or unauthorized' })
      end
    rescue => e
      status 400
      json({ status: 'error', message: e.message })
    end
  end
end