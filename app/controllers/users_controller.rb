class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers, :show]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,	 only: :destroy
  before_action :not_signed_in_user, only: [:new, :create]

  	def destroy
  		User.find(params[:id]).destroy
  		flash[:success] = "User deleted."
  		redirect_to users_url
  	end

	def index
		@users= User.paginate(page: params[:page])
	end

	def new
		@user = User.new
	end

  	

	def show
    	@user = User.find(params[:id])
    	@recipient = User.find(params[:id])
    	if signed_in? 
    	@micropost = current_user.microposts.build
    	@notes_item = current_user.notes(@user).first || Micropost.new
    	@conversation_items = current_user.conversation(@user).paginate(page: params[:page], :per_page => 7)
    	end
  	end

	def create
		@user = User.new(user_params)
		if @user.save
			sign_in @user
			flash[:success] = "Welcome to WhatsNapp!"
     		redirect_to root_url
  		else
  		render 'new'
  		end
	end

	def edit
	end

	def update
		if @user.update_attributes(user_params)
			flash[:success] = "Profile updated"
      		redirect_to @user
		else
			render 'edit'
		end
	end

	def following
	    @title = "Following"
	    @user = User.find(params[:id])
	    @users = @user.followed_users.paginate(page: params[:page])
	    render 'show_follow'
	end

	def followers
	    @title = "Followers"
	    @user = User.find(params[:id])
	    @users = @user.followers.paginate(page: params[:page])
	    render 'show_follow'
	end


	private

		def user_params
			params.require(:user).permit(:name, :email, :password,
			:password_confirmation)
		end

		# Before filters

		def not_signed_in_user
			if signed_in?
				redirect_to root_url
			end
		end

		
		def correct_user
      		@user = User.find(params[:id])
      		redirect_to(root_url) unless current_user?(@user)
    	end

    	def admin_user
  			redirect_to(root_url) unless current_user.admin?
  		end

end
