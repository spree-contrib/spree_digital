module Spree
  module Admin
    module OrdersControllerDecorator
      def reset_digitals
        load_order
        @order.reset_digital_links!
        flash[:notice] = Spree.t(:downloads_reset, scope: 'digitals')
        redirect_to spree.edit_admin_order_path(@order)
      end
    end
  end
end

::Spree::Admin::OrdersController.prepend(Spree::Admin::OrdersControllerDecorator)
