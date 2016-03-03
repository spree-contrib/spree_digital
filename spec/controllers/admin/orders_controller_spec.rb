require 'spec_helper'

RSpec.describe Spree::Admin::OrdersController do

  context "with authorization" do
    stub_authorization!

    before do
      request.env["HTTP_REFERER"] = "http://localhost:3000"

      # ensure no respond_overrides are in effect
      if Spree::BaseController.spree_responders[:OrdersController].present?
        Spree::BaseController.spree_responders[:OrdersController].clear
      end
    end

    let(:order) { mock_model Spree::Order, complete?: true, total: 100, number: 'R123456789' }

    before do
      expect(Spree::Order).to receive_message_chain(:includes, :friendly, :find).and_return order
    end

    context '#reset_digitals' do
      it 'should reset digitals for an order' do
        expect(order).to receive(:reset_digital_links!)
        spree_get :reset_digitals, id: order.number
        expect(response).to redirect_to(spree.show_digitals_admin_order_path(order))
      end
    end
  end

end
