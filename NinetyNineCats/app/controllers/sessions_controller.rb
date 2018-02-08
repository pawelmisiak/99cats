class SessionsController < ApplicationController
  
  before_action :ensure_logged_in, {only: [:destroy]}
  before_action :ensure_logged_out, {except: [:destroy]}
  
  def new
      @user = User.new
      render :new
  end
  
  def create
    @user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )
    if @user
      login_user!
      redirect_to cats_url
    else
      flash.now[:errors] = ['Invalid Username/Password']
      @user = User.new(user_params)
      render :new
    end
  end
  
  def destroy
    self.logout!
    redirect_to cats_url
  end
  
  private
  def user_params
    params.require(:user).permit(:username, :password)
  end
end
