module Spree
  module Admin
    module OrdersControllerDecorator
      def self.prepended(base)
        base.before_action :load_data, only: :reset_digitals
      end
      
      def reset_digitals
        # load_order
        @order.reset_digital_links!
        flash[:notice] = Spree.t(:downloads_reset, scope: 'digitals')
        redirect_to spree.admin_order_path(@order)
      end
    end
  end
end

::Spree::Admin::OrdersController.prepend Spree::Admin::OrdersControllerDecorator if ::Spree::Admin::OrdersController.included_modules.exclude?(Spree::Admin::OrdersControllerDecorator)
