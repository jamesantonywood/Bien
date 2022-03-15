class SessionsController < ApplicationController

    def new
        # log in form
    end

    def create
        # try to log in
        # get session params from the form
        @form_data = params.require(:session)
        # pull out the username and password from form data
        @username = @form_data[:username]
        @password = @form_data[:password]
        
        # lets check the user is who they say they are
        @user = User.find_by(username: @username).try(:authenticate, @password)

        # if user is valid
        if @user

            # save the user to that users session
            session[:user_id] = @user.id

            # go to homepage
            redirect_to root_path
        else
            # rerender login form
            render "new"
        end  
    end

    def destroy
        # log out
        # remove the session completly
        reset_session
        # redirect to log in
        redirect_to new_session_path
    end

    

end
 