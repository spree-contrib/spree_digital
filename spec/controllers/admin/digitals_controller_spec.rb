require 'spec_helper'

describe Spree::Admin::DigitalsController do
  stub_authorization!

  let!(:product) { create(:product) }

  context '#index' do
    render_views

    context "with variants" do
      let(:digitals) { 3.times.map { create(:digital) } }
      let(:variants_with_digitals) do
        digitals.map { |d| create(:variant, product: product, digitals: [d]) }
      end
      let(:variants_without_digitals) { 3.times.map { create(:variant, product: product) } }

      it "should display an empty page when no digitals exist" do
        variants_without_digitals
        spree_get :index, product_id: product.permalink
      end

      it "should display list of digitals when they exist" do
        
      end
    end

    context "without non-master variants" do

      it "should display an empty page when the master variant is not digital" do
        spree_get :index, product_id: product.permalink
        response.code.should == "200"
        response.body.should include("This product has no variants")
        response.body.should_not include('A digital version of this product currently exists')
      end

      it "should display the variant details when the master is digital" do
        @digital = create :digital, :variant => product.master
        spree_get :index, product_id: product.permalink
        response.code.should == "200"
        response.body.should include('A digital version of this product currently exists')
      end
      
    end
  end

  context '#create' do
    context 'for a product that exists' do
      let!(:variant) { create(:variant, product: product) }

      it 'creates a digital associated with the variant and product' do
        lambda {
          spree_post :create, product_id: product.permalink, 
                              digital: { variant_id: variant.id, 
                                         attachment: upload_image('thinking-cat.jpg') }
          response.should redirect_to(spree.admin_product_digitals_path(product))
        }.should change(Spree::Digital, :count).by(1)
      end
    end
  end

  context '#destroy' do
    let(:digital) { create(:digital) }
    let!(:variant) { create(:variant, product: product, digitals: [digital]) }

    context 'for a digital and product that exist' do
      it 'deletes the associated digital' do
        lambda {
          spree_delete :destroy, product_id: product.permalink, id: digital.id
          response.should redirect_to(spree.admin_product_digitals_path(product))
        }.should change(Spree::Digital, :count).by(-1)
      end
    end
  end
end