module Spree
  class Admin::DigitalsController < Spree::Admin::ResourceController
    belongs_to "spree/product", :find_by => :permalink
    
    protected
      def location_after_save
        spree.admin_product_digitals_path(@product)
      end

      def permitted_resource_params
        params.require(:digital).permit(permitted_digital_attributes)
      end

      def permitted_digital_attributes
        [:variant_id, :attachment]
      end
  end
end
