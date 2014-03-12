class MicropostsController < ApplicationController
  protect_from_forgery except: :show
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  skip_before_action :verify_authenticity_token
  
  def create
    @micropost = current_user.microposts.build(micropost_params)
    @user= User.find_by_id(@micropost.recipient_id) 
    if signed_in?
      @conversation_items = current_user.conversation(User.find_by_id(@micropost.recipient_id)).paginate(page: params[:page], :per_page => 7)
    end
    @micropost.new = true
    if @micropost.save
      flash[:success] = "You just sent a message to #{User.find_by_id(@micropost.recipient_id).name}"
      respond_to do |format|
        format.html { redirect_to User.find_by_id(@micropost.recipient_id) }
        format.js
      end

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