module Spree
  class Admin::DigitalsController < Spree::Admin::ResourceController
    belongs_to "spree/product", :find_by => :permalink
    
    protected
      def location_after_save
        spree.admin_product_digitals_path(@product)
      end
  end
end
