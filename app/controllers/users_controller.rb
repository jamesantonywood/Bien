class UsersController < ApplicationController

    def index
        @users = User.all
    end

    def show

        @user = User.find_by(params[:username])

    end

    def new
        # a form for adding a new user
        @user = User.new
    end

    def create
        # take the form params
        # create a new user
        @user = User.new(form_params)
        # if its valid and it saves, go to the users index
        # if not, see the form with errors
        if @user.save
            # Save the session with the user
            session[:user_id] = @user.id

            redirect_to users_path
        else
            render "new"
        end
    end

    def form_params
        params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end


end
