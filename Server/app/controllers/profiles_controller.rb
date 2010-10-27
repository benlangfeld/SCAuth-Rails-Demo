class ProfilesController < ApplicationController
  respond_to :json

  def show
    if @user = User.find_by_email(params[:email])
      respond_with @user
    else
      respond_to do |format|
        format.json { head :not_found }
      end
    end
  end

  def find_current_user
    if current_user
      respond_with "{ \"email\" : \"#{current_user.email}\" }", :status => :ok
    else
      respond_to do |format|
        format.any(:xml, :json) { head :not_found }
      end
    end
  end
end
