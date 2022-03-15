class ApplicationController < ActionController::Base

    #before any page load find the current user
    before_action :find_current_user

    # Methods to use in views
    helper_method :is_logged_in?

    def find_current_user
        if is_logged_in? 
            @current_user = User.find(session[:user_id])
        else
            @current_user = nil
        end
    end

    #check login status
    def check_login
        unless is_logged_in?
            redirect_to new_session_path
        end
    end

    # is a user logged in
    def is_logged_in?

        session[:user_id].present?

    end

end
