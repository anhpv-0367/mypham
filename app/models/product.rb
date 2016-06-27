class Product < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  before_destroy :remove_image, if: :avatar?

  private

  def remove_image
    self.remove_avatar!
    FileUtils.remove_dir "#{Rails.root}/public/uploads/product/avatar/#{self.id}", true
    FileUtils.remove_dir "#{Rails.root}/public/public/my/upload/directory", true
  end
end
