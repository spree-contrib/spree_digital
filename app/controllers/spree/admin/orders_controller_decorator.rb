Spree::Admin::OrdersController.class_eval do
  def reset_digitals
    load_order
    @order.reset_digital_links!
    flash[:notice] = Spree.t(:downloads_reset, scope: 'digitals')
    redirect_to spree.show_digitals_admin_order_url(@order)
  end

  def show_digitals
    load_order
    render :show_digitals
  end
end
