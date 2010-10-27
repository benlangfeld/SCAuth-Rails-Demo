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
end
