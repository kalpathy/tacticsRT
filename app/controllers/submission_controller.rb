class SubmissionController < ApplicationController
  
   layout "master"
   
   
   def index
     @tempStudies=TemplateStudy.find(:all)
     
   end
   
   def new
     
      login= params[:login]
      usr=User.find_by_login(login)  # need to validate
      if usr.blank?
        flash[:error] = "We couldn't find your login. Have you registered yet?"
        @tempStudies=TemplateStudy.find(:all)
        render :action => "index"
        return
      end
      
      cs=ContouringSession.new
      templ= TemplateStudy.find(params[:site]) #validate
      
      cs.template_study_id = templ.id
      cs.rtstruct=params[:file] # need to validate that it exists, and check dicomness
      cs.user_id=usr.id
      cs.ready = false
      cs.save
      cs.generate_masks
   end
   
   
   
end
