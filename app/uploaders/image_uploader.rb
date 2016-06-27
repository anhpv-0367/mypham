class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process :resize_to_fit => [800, 800]

  version :thumb do
    process :resize_to_fill => [500,200]
  end

  def store_dir
    'public/my/upload/directory'
  end

  def cache_dir
    '/tmp/projectname-cache'
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def content_type_whitelist
    [/image\//]
  end

  def default_url
    "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  end
end
