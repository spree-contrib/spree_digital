require 'spec_helper'

RSpec.describe Spree::Admin::OrdersController do
  context 'with authorization' do
    stub_authorization!

    let(:store) { Spree::Store.default }
    let(:order) { create(:order, store: store) }

    context '#reset_digitals' do
      it 'should reset digitals for an order' do
        get :reset_digitals, params: { id: order.number }
        expect(response).to redirect_to(spree.edit_admin_order_path(order))
      end
    end
  end
end
