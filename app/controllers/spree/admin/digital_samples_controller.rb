module Spree
  class Admin::DigitalSamplesController < Spree::Admin::ResourceController
    belongs_to "spree/product", find_by: :permalink
  
    def index
      # we don't want to display these separately-- they're part of the digitals admin index
      redirect_to :controller =>:digitals, :action=>:index
    end
    
    protected
      def location_after_save
        admin_product_digital_samples_url(@product)
      end
  end
end