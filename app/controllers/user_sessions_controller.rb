class UserSessionsController < BaseController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit]
  
  layout 'admin'
  
  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      if SimpleConfig && SimpleConfig::SimpleUsers.after_login_path
        redirect_back_or_default send(SimpleConfig::SimpleUsers.after_login_path)
      else
        redirect_back_or_default account_path
      end
    else
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to new_user_session_url
  end
end
