Spree::Admin::OrdersController.class_eval do
  def reset_digitals
    load_order()
    @order.reset_digital_links!
    flash[:notice] = t(:downloads_reset)
    redirect_to edit_admin_order_url(@order)
  end
end
