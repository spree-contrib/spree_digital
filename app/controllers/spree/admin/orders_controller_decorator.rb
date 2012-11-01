Spree::Admin::OrdersController.class_eval do
  def reset_digitals
    @order.reset_digital_links!
    flash[:notice] = t(:downloads_reset)
    redirect_to admin_order_url(@order)
  end
end
