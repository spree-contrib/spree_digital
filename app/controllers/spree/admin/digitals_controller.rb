module Spree
  class Admin::DigitalsController < Spree::Admin::ResourceController
    belongs_to "spree/product", find_by: :permalink
    
    def load_resource
      @object = @product = Product.find_by_permalink(params[:product_id])
    end

    
    protected
      def location_after_save
        admin_product_digitals_url(@product)
      end
  end
end