class ProductUpsellController < ApplicationController
   before_action { protect_controllers(8) } 
  respond_to :html
  def list
	@ropupsprod = ROPUPSPROD.all
    respond_with(@ropupsprod)
  end

  def search
  end

  def details
  	@prod = "Selected Nothing"
  	if params.has_key?(:prod)
  	@ropupsprod = ROPUPSPROD.where("prod = ?", params[:prod])
  	@product_variants = ProductVariant.where("extproductcode = ?", params[:prod])
  	@prod = params[:prod]

  	@product_variant = ProductVariant.new(extproductcode: params[:prod], product_sell_type_id: 10001, price: @ropupsprod.first.sp, taxes: 0, shipping: @ropupsprod.first.postage + @ropupsprod.first.ship, total: @ropupsprod.first.sp  +  @ropupsprod.first.postage + @ropupsprod.first.ship)
   respond_with(@ropupsprod, @product_variants)
	end
  end
end
