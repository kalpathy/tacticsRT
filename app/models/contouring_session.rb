class ContouringSession < ActiveRecord::Base
  belongs_to :template_study
  has_attached_file :rtstruct
  has_many :structures, :dependent => :destroy
  belongs_to :user
  
  
  
  def generate_masks
      
  #    dicomRTDir=""
      dicomRTDir="/Users/jayashreekalpathy/Documents/visualization/jkc_mods/MIDAS_Journal_701_2/build/Debug/"
      
          
      c = "cd #{Dir.tmpdir}; " + dicomRTDir + 'itkDICOMRT' +' ' + self.rtstruct.path.gsub(/\s/,"\\ ") + ' ' + self.template_study.nii.path.gsub(/\s/,"\\ ") + ' ' + self.id.to_s + "_"
      puts c
      out=`#{c}`
      #puts out
      
      puts "done!"
      
      numStr=0
      fileNames=[]
      structureNames=[]

      numStr = nil
      cur_struct = nil

      out.split("\n").each do |l|
        if not numStr # have we figured out the number of structures yet?
          if l =~ /Number of structures/
            numStr= l.split(':').last.strip.to_i
          end
        else # if so, let's start looking for structures
          if not cur_struct # are we currently in a structure? if not:
            if l =~ /Structure name:/
              cur_struct = l.split(/Structure name:/).last
              structureNames << cur_struct.strip
            end
          else # we are in a structure; are we at the "File written:" line?
            if l=~ /File written/
              fname = l.split(':').last
              fileNames << fname.strip
              cur_struct = nil
            end
          end
        end
      end # ends parsing output from c
      
      fileNames.each_with_index do |f, i|
        # put together Structure objects
        so=Structure.new
        File.open("#{Dir.tmpdir}/#{f}") { |n| so.mask =n }
        so.structure_name=structureNames[i]
        ## jkc -structure set id
      #  sname='%'+ structureNames[i]+'%'
       # ssid=StructureSet.find_by_id(:conditions => ["name LIKE ?", sname])
        #if !ssid.nil? 
         # so.structure_set_id=ssid.first
        #end
        ## end jkc
        so.save
        self.structures << so
        
      end
      
      # clean up:
      fileNames.each do |f|
        File.unlink("#{Dir.tmpdir}/#{f}")
      end
      
      # ok, now to wire up the new Structure objects to the contour data
      
      ps = self.parsed_structures_and_contours # ps = "parsed structures"
      
      ps.each do |k,v| # k is an rt roi num, v is the structure data structure
        
        # find the corresponding structure object, and set up its rt metadata:
        struct = self.structures.detect { |s| s.structure_name == v['rt_description'] }
        next if struct.nil? # there can be structures with no points, in which case itkDICOMRT won't create masks, so there won't be Structure objects.

        struct.rt_modality = v['rt_modality']
        struct.rt_roi_num = v['rt_roi_num']
        struct.rt_description = v['rt_description']
        struct.save
        
        # now handle contours:
        v['contour_data'].each do |cont_data|
          cont = Contour.new
          cont.structure_id = struct.id
          cont.ref_roi_num = cont_data['ref_roi_num']
          cont.ref_sop_instance_uid = cont_data['ref_sop_instance_uid']
          cont.cont_data = cont_data['contour_data']
          logger.info("saving a new Contour object for structure #{struct.structure_name} for roi num: #{cont.ref_roi_num}")
          cont.save
        end

      end # ends for each structure
      
      
      # this contouring session (and its structures) is now ready for business!
      self.ready = true
      self.save
      
      # maybe send an email to let the user know that their file is ready? It's been about six minutes...
    
  end
  handle_asynchronously :generate_masks
  
  # uses ruby-dicom to pull out the structure and contour data. Assumes that the structures are already in the db (from generate_masks)
  def parsed_structures_and_contours
    
      obj = DICOM::DObject.new(self.rtstruct.path)

      rt_modality = obj['0008,0060'] # rtstruct modality
      rt_description = obj['0008,1030'] # study description

      structures = {}

      # first, get the Structure Set ROI Sequence, and map  ROI Number to ROI Names.

      roi_num_to_obs_labels = {}

      obj['3006,0020'].children.each do |roi|
        roi_num = roi['3006,0022'].value
        roi_name = roi['3006,0026'].value
        logger.info("Mapping ref_roi_num #{roi_num} to #{roi_name}")
        roi_num_to_obs_labels[roi_num] = roi_name
      end

      # next, get the doc's main child node:
      c = obj['3006,0039'] # ROI Contour Sequence tag

      return nil if c.nil?

      # each of these items has an ROI Display Color and also a Contour Sequence object.
      # the Contour Sequence is what we want
      top_items = c.children
      top_items.each do |cs_item|

        ref_roi_num = cs_item['3006,0084'].value
        cont_sequence = cs_item['3006,0040']

        this_struct = {}
        this_struct['rt_modality'] = rt_modality.value
        this_struct['rt_description'] = roi_num_to_obs_labels[ref_roi_num]
        this_struct['rt_roi_num'] = ref_roi_num

        contours = []

        # now to deal with the contents of the contour sequence:
        if not cont_sequence.nil?
          cont_sequence.children.each do |cs_seq_item|
            cont_im_seq = cs_seq_item['3006,0016']
            cont_geom_type = cs_seq_item['3006,0042'].value
            num_cont_points = cs_seq_item['3006,0046'].value
            cont_data = cs_seq_item['3006,0050'].value
            cisd = cont_im_seq.children.first.children
            ref_sop_class_uid =cisd.detect { |i| i.tag == '0008,1150' }
            ref_sop_instance_uid = cisd.detect { |i| i.tag == '0008,1155' }
            ref_frame_num =cisd.detect { |i| i.tag == '0008,1160' }

            cont = {}
            cont['ref_roi_num'] = ref_roi_num
            cont['ref_sop_instance_uid'] = ref_sop_instance_uid.value
            cont['contour_data'] = cont_data
            contours << cont
          end
        end

        this_struct['contour_data'] = contours
        structures[this_struct['rt_roi_num']] = this_struct

      end

      return structures
    
  end


  
end
