class SessionsController < ApplicationController 

    before_action :require_logged_in, only: :destroy
    before_action :require_logged_out, only: [:new, :create]
    def new 
        @user = User.new 
        render :new 
    end 

    def create  
        email = params[:user][:email]
        password = params[:user][:password]
        @user = User.find_by_credentials(email, password)
        
        if @user 
            login!(@user)
            flash[:msg] = ["Successfully Logged In"]
            redirect_to user_url(@user)
            return 
        end 
        flash[:msg] = @user.errors.full_messages
        render :new 
    end 

    def destroy 
        logout
        redirect_to new_session_url
    end 
end 