require 'grpc'
require 'post_service_services_pb'
require './services/post_service'

class PostServiceServer < Postservice::PostService::Service
  def create_post(request, _unused_call)
    PostService.create_post(
      user_id: request.user_id,
      content: request.content,
      media_urls: request.media_urls.to_a
    )
    Postservice::CreatePostResponse.new(status: 'success', message: 'Post created')
  end
end

def main
  server = GRPC::RpcServer.new
  server.add_http2_port('0.0.0.0:50051', :this_port_is_insecure)
  server.handle(PostServiceServer)
  server.run_till_terminated
end

main if __FILE__ == $PROGRAM_NAME
