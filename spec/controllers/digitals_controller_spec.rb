require 'spec_helper'

describe Spree::Admin::DigitalsController do
  before do
    @product = FactoryGirl.create :product

    controller.stub :authorize! => true
  end

  let(:product) { @product }

  context "with variants" do
    before do
      # TODO add variants with digital
    end

    it "should display an empty page when no digitals exist" do
      
    end

    it "should display list of digitals when they exist" do
      
    end
  end

  context "without variants" do
    render_views

    it "should display an empty page when no digitals exist" do
      spree_get :index, "product_id" => product.permalink
      response.code.should == "200"
      response.body.should include("This product has no variants")
    end

    it "should display list of digitals when they exist" do
      @digital = FactoryGirl.create :digital, :variant => product.master
      spree_get :index, :product_id => product.permalink
      response.code.should == "200"

    end
    
  end
end