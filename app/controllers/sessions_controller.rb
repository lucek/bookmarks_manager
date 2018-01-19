class SessionsController < ApplicationController
  def new
    # render the login form
  end

  def create
    @user = User.find_by("LOWER(email) = ?", user_params[:email].downcase)

    if @user.present? && @user.authenticate(user_params[:password])
      cookies.permanent.signed[:user_id] = @user.id
      flash[:success] = "You've been succesfully logged in"
      redirect_to dashboard_url
    else
      render :new
    end
  end

  def destroy
    cookies.delete(:user_id)
    flash[:success] = "You've been succesfully logged out"
    redirect_to login_url
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

end
