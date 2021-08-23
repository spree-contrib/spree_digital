require 'spec_helper'

RSpec.feature 'Add New Digital', :js do
  stub_authorization!

  let(:product) { create(:product_with_option_types, price: '1.99', cost_price: '1.00') }

  context 'to product without variant' do
    before do
      product.options.each do |option|
        create(:option_value, option_type: option.option_type)
      end
    end

    context 'without added digital' do
      scenario 'should display no digitals' do
        visit spree.admin_product_digitals_path(product)

        expect(page).to have_content('Variant "Master"')
        expect(page).to have_content(Spree.t('product_has_no_variants'))
        expect(page).to have_content(Spree.t(:add_new_file, scope: 'digitals'), count: 1)
      end
    end

    context 'with added digital' do
      scenario 'should display that digital for master variant' do
        digital = create(:digital, variant: product.master)
        visit spree.admin_product_digitals_path(product)

        expect(page).to have_content(digital.attachment_file_name)
        expect(page).to have_link('Delete this file')
        expect(page).to have_content('Variant "Master"')
        expect(page).to have_content(Spree.t('product_has_no_variants'))
        expect(page).to have_content(Spree.t(:add_new_file, scope: 'digitals'), count: 1)
      end
    end
  end

  context 'to product with variant' do
    before do
      create(:variant, product: product, price: 19.99)

      product.options.each do |option|
        create(:option_value, option_type: option.option_type)
      end
    end

    context 'without added digital' do
      scenario 'should no digitals' do
        visit spree.admin_product_digitals_path(product)

        expect(page).to have_content('Variant "Master"')
        expect(page).to have_content('Variant "Size: S"')
        expect(page).to have_content(Spree.t(:add_new_file, scope: 'digitals'), count: 2)
      end
    end

    context 'with added digital' do
      scenario 'should display that digital' do
        master_digital = create(:digital, variant: product.master)
        variant_digital = create(:digital, variant: variant)

        visit spree.admin_product_digitals_path(product)

        expect(page).to have_content(master_digital.attachment_file_name)
        expect(page).to have_content(variant_digital.attachment_file_name)
        expect(page).to have_link('Delete this file', count: 2)
        expect(page).to have_content('Variant "Master"')
        expect(page).to have_content('Variant "Size S"')
        expect(page).to have_content(Spree.t(:add_new_file, scope: 'digitals'), count: 2)
      end
    end
  end

  context 'without selected attachement' do
    scenario 'should display error message' do
      visit spree.admin_product_digitals_path(product)
      click_button('Upload')

      expect(page).to have_content("Attachment #{Spree.t('activerecord.errors.messages.attached')}")
    end
  end
end
