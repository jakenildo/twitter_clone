module SessionsHelper
  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  def logged_in?
    !current_user.nil?
  end
  
  def only_loggedin_users
    # Goes to login page UNLESS user is logged in
    redirect_to login_url unless logged_in?
  end
  
  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end

  # Returns the current logged-in user (if any).
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: session[:user_id])
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: cookies.encrypted[:user_id])
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    flash[:info] = "Goodbye!"
    @current_user = nil
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget_token
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
end
