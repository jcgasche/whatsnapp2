class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  
	def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.new = true
    if @micropost.save
      flash[:success] = "You just sent a message to #{User.find_by_id(@micropost.recipient_id).name}"
      redirect_to User.find_by_id(@micropost.recipient_id)
    else
      @feed_items = []
      render 'static_pages/help'
    end
  end

	def destroy
    @user=User.find_by_id(@micropost.recipient_id)
    @micropost.destroy
    redirect_to @user
  end

	private

    def micropost_params
      params.require(:micropost).permit(:content, :recipient_id, :new)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end