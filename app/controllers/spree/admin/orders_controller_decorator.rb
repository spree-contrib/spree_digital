Spree::Admin::OrdersController.class_eval do
  def reset_digitals
    load_order
    @order.reset_digital_links!
    flash[:notice] = Spree.t(:downloads_reset, scope: 'digitals')
    redirect_to spree.edit_admin_order_path(@order)
  end
end
