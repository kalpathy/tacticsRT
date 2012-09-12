class ComparisonController < ApplicationController
  
  layout "compare"
  
  def index
    
  end
  
  def setupstaple
    
    if params[:id].blank?
      flash[:notice] = "Try giving a file id..."
      render :action => "index"
      return
    end
    
    @c = ContouringSession.find(params[:id], :include => [:structures, :template_study])
    if @c.blank?
      flash[:notice] = "Couldn't find uploaded file"
      render :action => "index"
      return
    end
    
    # list of contouring sessions to compare against: (for section #1 on the page)
    # for now, this is all the contouring sessions from @c's template, except for @c- we can change this later to only get "expert" sessions, etc.
    @compare_against_list = ContouringSession.find(:all, :conditions => ["id <> :id and template_study_id = :ts_id and expert = 't'", {:id => @c.id, :ts_id => @c.template_study.id}], :include => [:user, :structures])
    
    
    # if provided, include a contouring session to compare against (for section #2 on the page)
    @compare_against = nil
    if params[:compare_id].present?
      @compare_against = ContouringSession.find(params[:compare_id], :include => [:structures, :user])
    end
    
    @result = nil
    @struct_1 = nil
    @struct_2 = nil
    @fig_url = nil
    if params[:struct_1].present? and params[:struct_2].present?
      @struct_1 = Structure.find(params[:struct_1])
      @struct_2 = Structure.find(params[:struct_2])
      
      return unless @struct_1.present? and @struct_2.present?

      # calc dice!

      metric_types=MetricType.find(:all)
      # have we already done this?
      
      @fig_urls = []
      @results = []
      
      metric_types.each do |mt|
        
        m = Metric.find(:first, :conditions => {:structure_1_id => @struct_1.id, :structure_2_id => @struct_2.id, :metric_type_id => mt.id}) # TODO: limit search to metric_type_id of 1 (for dice)
        if not m.present?
          logger.info("didn't find a metric...")
          # if we haven't calculated this already...
          temp_result = Metric.send(mt.method_name, @struct_1, @struct_2, true)
          m = Metric.create(:metric_type_id => mt.id, :structure_1_id => @struct_1.id, :structure_2_id => @struct_2.id, :value => temp_result)
        else
          logger.info("found a metric in the db...")
        end

        @results << m
      
        @fig_urls << generate_histogram_url(@c.template_study, m)
            
      end # ends metric_types
      
      logger.info("results.size: "+  @results.size.to_s)

    end # ends "if params[struct...]"
    
  end
  
  def destroy
    if params[:id].blank?
       flash[:notice] = "Try giving a file id..."
       render :action => "index"
       return
     end

     @cd = ContouringSession.find(params[:id], :include => [:structures, :template_study])
     if @cd.blank?
       flash[:notice] = "Couldn't find uploaded file"
       render :action => "index"
      else
        @cd.destroy
        render :action => "choose"
     end
    
  end
  
  
  def choose
    
    if params[:login].blank?
      flash[:notice] = "Please enter a login..."
      render :action => "index"
      return
    end
    
    @u = User.find_by_login(params[:login], :include => :contouring_sessions)
    if @u.blank?
      flash[:notice] = "Login not found; try again."
      render :action => "index"
      return
    end
    
    @c = @u.contouring_sessions
    
  end
  
  def setup
    
    if params[:id].blank?
      flash[:notice] = "Try giving a file id..."
      render :action => "index"
      return
    end
    
    @c = ContouringSession.find(params[:id], :include => [:structures, :template_study])
    if @c.blank?
      flash[:notice] = "Couldn't find uploaded file"
      render :action => "index"
      return
    end
    
    # list of contouring sessions to compare against: (for section #1 on the page)
    # for now, this is all the contouring sessions from @c's template, except for @c- we can change this later to only get "expert" sessions, etc.
    @compare_against_list = ContouringSession.find(:all, :conditions => ["id <> :id and template_study_id = :ts_id", {:id => @c.id, :ts_id => @c.template_study.id}], :include => [:user, :structures])
    
    
    # if provided, include a contouring session to compare against (for section #2 on the page)
    @compare_against = nil
    if params[:compare_id].present?
      @compare_against = ContouringSession.find(params[:compare_id], :include => [:structures, :user])
    end
    
    @result = nil
    @struct_1 = nil
    @struct_2 = nil
    @fig_url = nil
    if params[:struct_1].present? and params[:struct_2].present?
      @struct_1 = Structure.find(params[:struct_1])
      @struct_2 = Structure.find(params[:struct_2])
      
      return unless @struct_1.present? and @struct_2.present?

      # calc dice!

      metric_types=MetricType.find(:all)
      # have we already done this?
      
      @fig_urls = []
      @results = []
      
      metric_types.each do |mt|
        
        m = Metric.find(:first, :conditions => {:structure_1_id => @struct_1.id, :structure_2_id => @struct_2.id, :metric_type_id => mt.id}) # TODO: limit search to metric_type_id of 1 (for dice)
        if not m.present?
          logger.info("didn't find a metric...")
          # if we haven't calculated this already...
          temp_result = Metric.send(mt.method_name, @struct_1, @struct_2, true)
          m = Metric.create(:metric_type_id => mt.id, :structure_1_id => @struct_1.id, :structure_2_id => @struct_2.id, :value => temp_result)
        else
          logger.info("found a metric in the db...")
        end

        @results << m
      
        @fig_urls << generate_histogram_url(@c.template_study, m)
            
      end # ends metric_types
      
      logger.info("results.size: "+  @results.size.to_s)

    end # ends "if params[struct...]"
    
  end

  private
  def generate_histogram_url(template, met)
#return "" # this is because, when tehre's only one or two metrics, the histogram is screwy
    bar_color = "0000ff"
    highlight_color = "ff0000"
    
    hist = met.metric_type.histogram(template, met)

    bc = GoogleChart::BarChart.new('550x200', "Histogram", :vertical, false)

    # calculate color order:
    bars = hist[:counts].collect { |h| bar_color }
    logger.info('hist[:bin] is: ' + hist[:bin].to_s)

    if hist[:bin].present?
      bars[hist[:bin]] = highlight_color
    end
    
    bc.data "Count", hist[:counts], bars.join('|') 
    bc.show_legend = false
    bc.axis :x, :labels => hist[:breaks], :alignment => :left
    return bc.to_url(:chxp => "0,0")
    
  end
  
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "tactics" && password == "tactics"
    end
  end
    
end
