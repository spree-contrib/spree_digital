require 'spec_helper'

RSpec.describe "spree/order_mailer/confirm_email", type: :view do
  let(:order) do
    create(:order, line_items: [create(:line_item, variant: create(:variant))])
  end

  before { assign(:order, order) }
  subject { render }

  it { should match order.line_items[0].variant.options_text}
end
