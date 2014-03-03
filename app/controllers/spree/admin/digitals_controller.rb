module Spree
  module Admin
    class DigitalsController < ResourceController
      belongs_to "spree/product", :find_by => :slug

      def create
         invoke_callbacks(:create, :before)
         @object.attributes = permitted_resource_params
         if @object.save
           invoke_callbacks(:create, :after)
           flash[:success] = flash_message_for(@object, :successfully_created)
           respond_with(@object) do |format|
             format.html { redirect_to location_after_save }
             format.js   { render :layout => false }
           end
         else
           invoke_callbacks(:create, :fails)
           redirect_to location_after_save
         end
       end

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
end
