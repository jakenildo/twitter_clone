module StaticpagesHelper
     # Returns true if the given user is the current user.
     def current_user?(user)
        user == current_user
    end

    # Returns the current logged-in user (if any).
    def current_user
        if session[:user_id]
        @current_user ||= User.find_by(id: session[:user_id])
        end
    end
end
