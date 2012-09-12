class VisualizeStructureController < ApplicationController

	def index
		@structure = Structure.find(params[:id])
	end

	def compare
		@structure1 = Structure.find(params[:struct1])
		@structure2 = Structure.find(params[:struct2])
	
		@struct1_sop_hash = {} # keys are ref_sop_instance_uid, val is contour object
		@struct2_sop_hash = {}

		@sop_z_index_hash= {} # should match sop_instance_uids to pairs of z-indicies
	
		@structure1.contours.each do |c|
		#	pts = parse_points(c.cont_data, false) #jkc comment
		scale_x=@structure1.contouring_session.template_study.x_scale.to_f
		scale_y=@structure1.contouring_session.template_study.x_scale.to_f
		orig_x=@structure1.contouring_session.template_study.x_orig.to_f
		orig_y=@structure1.contouring_session.template_study.y_orig.to_f
		
		
			pts = parse_points(c.cont_data,scale_x, scale_y, orig_x, orig_y, true) #jkc
			
			@sop_z_index_hash[c.ref_sop_instance_uid] = pts[0][2]
			if @struct1_sop_hash[c.ref_sop_instance_uid].nil?  # to account for multiple closed contours
			  @struct1_sop_hash[c.ref_sop_instance_uid]=[pts]
		  else
			  @struct1_sop_hash[c.ref_sop_instance_uid] << pts
		  end
		end

    @structure2.contours.each do |c|
      scale_x=@structure1.contouring_session.template_study.x_scale.to_f
  		scale_y=@structure1.contouring_session.template_study.x_scale.to_f
  		orig_x=@structure1.contouring_session.template_study.x_orig.to_f
  		orig_y=@structure1.contouring_session.template_study.y_orig.to_f
      
			pts = parse_points(c.cont_data, scale_x, scale_y, orig_x, orig_y, true)
  		if not @sop_z_index_hash[c.ref_sop_instance_uid]
  			@sop_z_index_hash[c.ref_sop_instance_uid] = pts[0][2]
  		end
      if @struct2_sop_hash[c.ref_sop_instance_uid].nil?
        @struct2_sop_hash[c.ref_sop_instance_uid]=[pts]
      else 
        @struct2_sop_hash[c.ref_sop_instance_uid] << pts
      end
    end

		@all_sop_uid = [@struct1_sop_hash.keys, @struct2_sop_hash.keys].flatten.uniq.sort { |x,y| @sop_z_index_hash[x] <=> @sop_z_index_hash[y] }

		
		
	end


#	private  #commented jkc

  # translate: defaults to true; translates points to fall naturally on a coordinate system with the origin in the upper-left
  # =>         corner, rather than the DICOM standard center of the image.
	def parse_points(pts, scale_x, scale_y, orig_x, orig_y, translate=true)

		point_arr = []
		points = pts.split("\\")
		points.each_slice(3) do |i|
		  raw_x = i[0].to_f
		  raw_y = i[1].to_f
		  raw_z = i[2].to_f
		  scale=1.13777
		  
		  # orig in real space =-225-256*0.8=20.2
		  if translate
			 # x = raw_x * -1.0 + 256.0
			#  y = raw_y * -1.0 + 256.0
		#	  x=(raw_x + 225.0)*scale
		#	  y=(raw_y + 225.0)*scale
		
		    x=(raw_x -orig_x)/scale_x
		    y=(raw_y -orig_y)/scale_y
		
			  z = raw_z # no need to translate
			else
			  x = raw_x
			  y = raw_y
			  z = raw_z
		  end
			point_arr << [x,y,z]
		end

		return point_arr

	end

end
