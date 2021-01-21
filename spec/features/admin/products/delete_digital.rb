require 'spec_helper'

RSpec.feature 'Delete Digital', :js do
  stub_authorization!

  let(:product) { create(:product_with_option_types, price: '1.99', cost_price: '1.00') }

  context 'from master variant' do
    scenario 'should remove existing digital' do
      product.options.each do |option|
        create(:option_value, option_type: option.option_type)
      end

      digital = create(:digital, variant: product.master)
      visit spree.admin_product_digitals_path(product)

      expect(page).to have_content('Variant "Master"')
      expect(page).to have_content(Spree.t('product_has_no_variants'))
      expect(page).to have_content(digital.attachment_file_name)

      click_link('Delete this file')page.driver.browser.switch_to.alert.accept

      expect(page).to have_content('Digital has been successfully removed!'))
      expect(page).to have_content(Spree.t('product_has_no_variants'))
    end
  end

  context 'from master variant' do
    scenario 'should remove existing digital' do
      variant = create(:variant, product: product, price: 19.99)
      product.options.each do |option|
        create(:option_value, option_type: option.option_type)
      end

      digital = create(:digital, variant: variant)
      visit spree.admin_product_digitals_path(product)

      expect(page).to have_content(digital.attachment_file_name)
      expect(page).to have_link('Delete this file')
      expect(page).to have_content('Variant "Master"')
      expect(page).to have_content('Variant "Size: S"')
      expect(page).to have_content(Spree.t(:add_new_file, scope: 'digitals'), count: 2)
      
      find('Delete this file').click
      click_link('Delete this file')
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content('Digital has been successfully removed!'))
      expect(page).to have_content(Spree.t('product_has_no_variants'), count: 2)
    end
  end
end
