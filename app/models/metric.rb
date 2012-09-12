class Metric < ActiveRecord::Base
  belongs_to :metric_type
  belongs_to :structure_1, :class_name => "Structure", :foreign_key => "structure_1_id"
  belongs_to :structure_2, :class_name => "Structure", :foreign_key => "structure_1_id"
  
  def self.dice(struct1, struct2, parse_output = false)
    
    c=C3D_CMD  + ' '+struct1.mask.path.gsub(/\s/,"\\ ") + ' ' + struct2.mask.path.gsub(/\s/,"\\ ") + ' '+'-overlap 1' 
    out = `#{c}`
    
    return out unless parse_output
    
    parsedOut=out.split(',')[4].to_f
    return parsedOut
    
  end
  
  def self.hausdorff(struct1, struct2, parse_output = false)
    
    c=C3D_CMD + ' '+struct1.mask.path.gsub(/\s/,"\\ ") + ' ' + struct2.mask.path.gsub(/\s/,"\\ ") + ' '+'-overlap 1' 
    out = `#{c}`
    
    return out unless parse_output
    #puts parsedOut
    parsedOut=out.split(',')[4].to_f
    return parsedOut
    
  end
  
  def template_matches?(template)
    first_match = self.structure_1.template_study == template
    second_match = self.structure_2.template_study == template
    return first_match && second_match
  end
  
  
end
