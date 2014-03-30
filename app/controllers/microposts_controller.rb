class MicropostsController < ApplicationController
  protect_from_forgery except: :show
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  #skip_before_action :verify_authenticity_token
  
  def create
    @micropost = current_user.microposts.build(micropost_params)
    @user= User.find_by_id(@micropost.recipient_id) 
    if @micropost.is_note
      @old_notes= current_user.notes(@user).first
      if @old_notes
        @old_notes.destroy
      end
      #@old_notes= current_user.notes(@user).first
    end
    if signed_in?
      @conversation_items = current_user.conversation(@user).paginate(page: params[:page], :per_page => 7)
    end
    @micropost.new = true
    if @micropost.save
      #flash[:success] = "You just sent a message to #{User.find_by_id(@micropost.recipient_id).name}"
      respond_to do |format|
        format.html { redirect_to @user }
        format.js
      end
    else
      @feed_items = []
      redirect_to @user
    end
  end

  def destroy
    @user=User.find_by_id(@micropost.recipient_id)
    @micropost.destroy
    redirect_to @user
  end


  #this code has just been copy pasted from stack overflow
  def update

    if params[:commit]=="Pin to the notes" && signed_in? 
      @current_user= User.find_by_id(micropost_params[:user_id])
      #!!! recipient_id is not the recipient_id of the message but the "other guy" in the conversation!
      #!! @user is the user being viewed by the current_user (here found in the parameters to avoid a long db search)
      @user= User.find_by_id(micropost_params[:recipient_id])

      @notes_item= @current_user.notes(@user).first || Micropost.new
      @notes = micropost_params[:content] << "\n \n"<< @notes_item.content.to_s
      @notes_item.update_attributes( content: @notes)

      #building variables for page usage
      #@user has already been built upper, as well as @notes_item 
      @micropost = current_user.microposts.build(micropost_params) 
      @conversation_items = @current_user.conversation(@user).paginate(page: params[:page], :per_page => 7) 

      respond_to do |format|
          format.html { redirect_to @user }
          format.js
        end
    end

  end
  #end of copy pasted code.

  def has_been_read
    self.new = false
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :recipient_id, :new, :is_note, :user_id)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
end