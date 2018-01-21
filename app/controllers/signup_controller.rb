class SignupController < ApplicationController
  layout "login"

  def new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      cookies.signed[:user_id] = @user.id
      flash[:success] = "Your account has been created"
      redirect_to dashboard_url
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
