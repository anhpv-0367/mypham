class Product < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
end
