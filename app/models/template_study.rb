class TemplateStudy < ActiveRecord::Base
  has_many :contouring_sessions
  has_attached_file :nii
end
