class RegistrationController < ApplicationController
  
  layout "master"
  
  def index
    
  end
  
  def new
    u = User.new(params[:user])
    # TODO: sort this out
  # u.password = "password"
  # u.password_confirmation = "password"
    if not u.save
      redirect_to :action => "index"
    end
    
  end
  
end
