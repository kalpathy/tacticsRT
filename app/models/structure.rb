class Structure < ActiveRecord::Base
  belongs_to :contouring_session
  has_attached_file :mask
  has_many :contours, :dependent => :destroy

  
  def template_study
    return self.contouring_session.template_study
  end
  
  
end
