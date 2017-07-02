class AvatarUploader < CarrierWave::Uploader::Base
  storage :file

  def default_url
    url = "fallback/" << [version_name, Settings.no_avatar].compact.join("_")
    ActionController::Base.helpers.asset_path url
  end

  def store_dir
    "avatars/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end
