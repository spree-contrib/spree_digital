module Spree
  module Admin
    class DigitalsController < ResourceController
      include Downloadable
      
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

      def show
        send_file attachment.path, filename: attachment.original_filename, type: attachment.content_type, status: :ok and return
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
      
      private

        def attachment
          @attachment = Digital.find(params[:id]).attachment
        end

        def authorized?
          true
        end
    end
  end
end
