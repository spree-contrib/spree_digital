module Spree
  module Admin
    class DigitalsController < ResourceController
      belongs_to "spree/product", :find_by => :slug
      
      def create
        invoke_callbacks(:create, :before)
        @object.attributes = permitted_resource_params

        if @object.valid?
          super
        else
          invoke_callbacks(:create, :fails)
          flash[:error] = @object.errors.full_messages.join(", ")
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
        [:variant_id, :attachment, :resource_url]
      end
    end
  end
end
