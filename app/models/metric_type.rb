class MetricType < ActiveRecord::Base
  has_many :metrics, :include => [{:structure_1 => {:contouring_session => :template_study}}, {:structure_2 => {:contouring_session => :template_study}}]
  
  def histogram(template, met=nil) # will only use metrics for structures based on this template
    
    if ENV['R_HOME'].blank?
      # ENV['R_HOME'] = "/usr/lib/R" #on skynet
      ENV['R_HOME']="/Library/Frameworks/R.framework/Resources" # on mac
      
    end
    
    r=RSRuby.instance
    
    # get the data:
    d = self.metrics.select { |m| m.template_matches? template}.collect { |m| m.value.to_f }
    
    t = r.hist(d, :xlab => "#{self.name}", :main => "Histogram of #{self.name}")
    
    to_return = {:counts => t['counts'], :breaks => t['breaks']}
    
#    logger.info("counts:" + t['counts'].join(', '))
    
    if met
      # figure out which bin met.value falls into    
      # bin <- cut(thisObs, h$breaks)
      cut = r.cut(met.value.to_f, t['breaks'])
      bin = cut.split(',').first.gsub('(','').to_f
      
      # TODO: figure out why we have to do string comparison- floats should be working here...
      to_return[:bin] = t['breaks'].map(&:to_s).index(bin.to_s)
      
#      logger.info("match: #{t['breaks'][1].class == bin.class}")
#      logger.info("breaks: #{t['breaks'].join(', ') }")
#      logger.info("cut was : #{cut}, bin is: #{bin}, [:bin] is: #{to_return[:bin]}")
    end
    
    return to_return
    
  end
  
end
