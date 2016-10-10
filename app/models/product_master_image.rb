class ProductMasterImage < ActiveRecord::Base
    mount_uploader :name, ProductMasterImageUploader
end
