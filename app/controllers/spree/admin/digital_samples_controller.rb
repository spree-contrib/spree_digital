module Spree
  class Admin::DigitalSamplesController < Spree::Admin::ResourceController
    belongs_to "spree/product", find_by: :permalink
    
    protected
      def location_after_save
        admin_product_digitals_url(@product)
      end
  end
end