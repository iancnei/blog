class SessionsController < ApplicationController

  #
  # GET /login
  #
  def new
  end

  #
  # POST /sessions
  #
  def create
    if user_params[:email].present? && user_params[:password].present?
      # email and password entered, ok
      if User.find_by(email: user_params[:email])
        # found a user, ok
        auth_user = User.confirm user_params
        if auth_user
          # user authorized, ok
          login auth_user
          # pass either auth_user or auth_user.id to the path helper
          # -> Rails will figure it out
          redirect_to user_path(auth_user),
            flash: { success: "Logged in successfully" }
        else
          # bad password
          flash.now[:danger] = "Invalid password"
          # display the login page again
          render :new
        end
      else
        # user not found
        flash[:warning] = "User not found"
        # have them sign up
        redirect_to signup_path
      end
    else
      # incomplete login fields
      flash.now[:danger] = "Please enter your email and password"
      render :new
    end
  end

  def destroy
    logout
    redirect_to '/', flash: { info: "Goodbye"}
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

end
