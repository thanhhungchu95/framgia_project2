class PostPictureUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "post_pictures/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end
