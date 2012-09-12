class ContouringSessionController < ApplicationController
  
  
  def show
    @cs = ContouringSession.find(params[:id])
  end
  
end
