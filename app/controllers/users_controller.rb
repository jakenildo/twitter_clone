class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "User info updated!!"
      redirect_to @user
    else
      flash[:danger] = "Update failed!"
      render 'edit'
    end
  end


  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
      if @user.save
        flash[:success] = "Welcome!"
        redirect_to login_url
      else
        flash[:danger] = "Signup failed!"
        render 'new'
      end
  end

  def show
    @user = User.find(params[:id])
    @micropost = current_user.microposts.build
    @feed_items = @user.microposts.paginate(page: params[:page], per_page: 12)
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:danger] = "User Deleted!"
    redirect_to users_url
  end

  before_action :only_loggedin_users, only: [:index, :edit, :update,
                                             :destroy, :following, :followers,
                                             :like, :dislike]

  before_action :correct_user,   only: [:edit, :update]

  def index
    @users = User.paginate(page: params[:page], per_page: 10 )
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page], per_page: 5)
    @all_users = @user.followed_users
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page], per_page: 5)
    @all_users = @user.followers
    render 'show_follow'
  end


  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
 
end
