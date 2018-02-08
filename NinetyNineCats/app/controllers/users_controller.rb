class UsersController < ApplicationController
  
  before_action :ensure_logged_in, {only: [:destroy]}
  before_action :ensure_logged_out, {except: [:destroy]}
  
  def new
    @user = User.new
    render :new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      login_user!
      redirect_to cats_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:username, :password)
  end
end

