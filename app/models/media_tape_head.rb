class MediaTapeHead < ActiveRecord::Base
	#belongs to product variant, medium, 
	belongs_to :product_variant, foreign_key: "product_variant_id"

	has_many :media_tape, foreign_key: "media_tape_head_id"

	validates :product_variant_id, presence: true
	validates :name, presence: true , uniqueness: { case_sensitive: false,
    message: "There is already media tape heading with that name you cant have the same name" }

    def parts
    	if MediaTape.where(media_tape_head_id: self.id).present?
    		return MediaTape.where(media_tape_head_id: self.id).count()
    	else
    		0
    	end
    end
end
