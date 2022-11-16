class UsersController < ApplicationController 

    def new 
        @user = User.new 
        render :new 
    end 

    def create 
        @user = User.new(users_params)
        if @user.save 
            login!(@user)
            flash[:msg] = ["Successfully Logged In"]
            redirect_to user_url(@user)
        else 
            flash[:msg] = @user.errors.full_messages
            render :new 
        end 
    end 

    def show 
        @user = User.find_by(email: params[:email])
        render :show 
    end 

    private 
    def users_params 
        params.require(:user).permit(:email, :password)
    end 

end 