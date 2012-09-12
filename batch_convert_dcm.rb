require 'rubygems'
require 'dicom'
require 'RMagick'

#indir = ARGV[0].split('/').first
indir='/Users/jayashreekalpathy/Documents/tactics/webapp/tactics/public/images/imagesOrig'
puts indir

outdir = '/Users/jayashreekalpathy/Documents/tactics/webapp/tactics/public/images/thumbs/1'

puts outdir


count = 0

Dir[indir + "/*.dcm"].each do |dcm|
  #break if count >= 10
  count +=1 
  puts dcm
  fname = dcm.split("/").last
  puts fname
  base_name = fname[0,fname.length-4] # get rid of .dcm extension
  puts base_name
  obj = DICOM::DObject.new(dcm, :verbose => true)
  image = obj.get_image_magick
  
  outName=outdir + "/" + base_name + ".jpg"
  puts outName
  image.write(outName)
end