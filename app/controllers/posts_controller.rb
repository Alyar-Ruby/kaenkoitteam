class PostsController < ApplicationController
  
  def create
    @permission = true
    if check_permission == true 
      @post = Post.new(post_params)
      @post.from_user_id = current_user.id
      @post.from_account_id = current_user.account.id
      @post.save
      @account = Account.find_by_id(post_params[:to_account_id])

      KaenkoNotification.new(:from_user_id=>current_user.id, :from_account_id => current_user.account.id, :to_user_id=>"",
        :message=>"added a Post", :to_account_id => post_params[:to_account_id] , :url=>social_user_path(@account.id), 
        roleable_type: "Post" , roleable_id: @post.id).save
      @connection = Array.new
      if @account.present?
        c1 = Connection.where(from_account_id: current_user.account.id, to_account_id: @account.id)
        c2 = Connection.where(to_account_id: current_user.account.id, from_account_id: @account.id)
         if c1.present? && !c2.present?
          @connection  = c1
         else
          @connection  = c2
         end
        @user_connections = Connection.user_all_connection(@account)      
        @posts = Post.where("to_account_id = ?", @account.id).order("created_at desc").includes(:comments)
      end
    else
      @permission = false
    end
  end

  def edit
    @post = find_post
  end

  def update
    @post = find_post
    if @post.update_attributes(post_params)
       @post.from_user_id = current_user.id
       @post.save
    end
  end

  def destroy
    @post = find_post
    @id = @post.id
    @post.destroy
  end

  def make_private
    @post = find_post
    @post.update_attributes(is_private: true)
  end

  def make_public
    @post = find_post
    @post.update_attributes(is_private: false)
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end

  def check_permission
    current_user.user_permission("Add Post")
  end

  def post_params
    params.require(:post).permit(:title, :to_account_id)
  end
end
