# encoding: utf-8

class DesignUploader < CarrierWave::Uploader::Base

  # Include RMagick or ImageScience support:
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes
  # include CarrierWave::MiniMagick
  # include CarrierWave::ImageScience

  # Choose what kind of storage to use for this uploader:
  #storage :file
  #storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  if Rails.env.production?
    def store_dir
      "#{model.class.to_s.underscore}"
    end
  else
    def store_dir
      "test_taolinggan"
    end
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    "images/" + [version_name]+".jpg"
  end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  process :resize_to_limit => [700, nil]

  version :thumb do
    process :resize_to_limit => [360, nil]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    #"something.jpg" if original_filename
    if super.present?
      @name = Digest::MD5.hexdigest(File.dirname(current_path))
      "#{@name}.#{file.extension.downcase}"
    end

  end
  # https://github.com/jnicklas/carrierwave/wiki
  # Heroku has a read-only filesystem, so uploads must be stored on S3 and cannot be cached in the public
  # directory. You can work around the caching limitation by setting the cache_dir in your Uploader classes
  # to the tmp directory.
  #def cache_dir
  #  "#{Rails.root}/tmp/uploads"
  #end
end

