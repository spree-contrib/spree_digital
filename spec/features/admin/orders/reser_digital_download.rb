require 'spec_helper'

RSpec.feature 'Reset Digital Download', :js do
  stub_authorization!

  let(:order)     { create(:completed_order_with_totals, number: 'R100', line_items_count: 1) }
  let(:line_item) { order.line_items.first }
  let(:variant)   { line_item.variant }

  context 'link is present for an order' do
    let!(:digital) { create(:digital, variant: variant) }

    scenario 'when all variants have digitals' do
      visit spree.edit_admin_order_path(order)

      click_link Spree.t(:reset_downloads, scope: 'digitals')
      expect(page).to have_content(Spree.t(:downloads_reset, scope: 'digitals'))
    end
  end

  context 'link is absent for an order' do
    scenario 'when not all variants have digitals' do
      visit spree.edit_admin_order_path(order)

      expect(page).to_not have_content(Spree.t(:reset_downloads, scope: 'digitals'))
    end
  end
end
