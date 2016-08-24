class CommentsController < ApplicationController
  respond_to :json, :html, :js
  def create
    @permission = true
    if check_permission == true 
      @post = Post.find(params[:post_id])
      @comment = @post.comments.new(comment_params)
      @comment.user_id = current_user.id
      @comment.account_id = current_user.account.id
      @comment.save
      if @post.from_account_id != current_user.account.id
          KaenkoNotification.new(:from_user_id=>current_user.id, :from_account_id => current_user.account.id, :to_user_id=>@post.to_user_id,
               :to_account_id => @post.from_account_id, :message=>"commented a Post", roleable_type: "Comment" , roleable_id: @comment.id,
              :url=>social_user_path(@post.to_account_id)).save
      end
    else
      @permission = false
    end
  end

  def destroy
    @comment =  Comment.find(params[:id])
    @comment_id = params[:id]
    @comment.destroy
  end

  private

  def check_permission
      current_user.user_permission("Add Comment")
  end

  def comment_params
      params.require(:comment).permit(:title)
  end
end
