# encoding: utf-8

class BusinessImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
   include CarrierWave::MiniMagick
   include CarrierWave::MimeTypes

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog
  #process :set_content_type
  
  def resize_to_width(width)
    manipulate! do |img|
      img.resize "#{width}x"
      img = yield(img) if block_given?
      img
    end
  end
  
  version :profile do
    process :resize_to_fill=> [125, 125]
  end
  
  version :circle do
    process :resize_to_fill => [67, 67] # crop to 182 x 182
    process :round_image                  # then round it out
  end

  def round_image

   FileUtils.mkdir_p "public/#{store_dir}" if !File.directory?( "public/#{store_dir}" )

   manipulate! do |img|

     new_tmp_path = File.join(Rails.root, 'public', store_dir, "/business_round_#{File.basename(path)}")

     width, height = img[:dimensions]

     #puts "*************** img.inspect: #{img.inspect}"
     #puts "************** store_dir: #{store_dir}"

     # if the uploads/users/user_2 dir does not exist then create it
     #puts "************** File.directory?('store_dir'): #{File.directory?( store_dir )}"



     radius_point = ((width > height) ? [width / 2, height] : [width, height / 2]).join(',')

     imagemagick_command = ['convert',
                            "-size #{ width }x#{ height }",
                            'xc:transparent',
                            "-fill #{ path }",
                            "-draw 'circle #{ width / 2 },#{ height / 2 } #{ radius_point }'",
                            # "+repage #{File.basename(path)}"].join(' ')
                            "+repage #{new_tmp_path}"].join(' ')


     #puts "************* imagemagick_command: #{imagemagick_command}"


     system( imagemagick_command )

     # MiniMagick::Image.open( File.basename(path) )
     MiniMagick::Image.open( new_tmp_path )

   end
 end
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
   #version :thumb do
   # process :scale => [50, 50]
   #end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
   def extension_white_list
     %w(jpg jpeg gif png)
   end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
  before :cache, :capture_size_before_cache # callback, example here: http://goo.gl/9VGHI
  def capture_size_before_cache(new_file) 
    if model.avatar_upload_width.nil? || model.avatar_upload_height.nil?
      model.avatar_upload_width, model.avatar_upload_height = `identify -format "%wx %h" #{new_file.path}`.split(/x/).map { |dim| dim.to_i }
    end
  end

end
