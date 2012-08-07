require 'spec_helper'

describe Spree::Variant do
  before do
    @product = FactoryGirl.create :product
    @digital = FactoryGirl.create :digital, :variant => @product.master
  end

  let(:variant) { @product.master }

  it "should delete all digitals on variant#destroy" do
    digital_id = variant.digitals.first.id
    Spree::Digital.find(digital_id).should_not be_nil
    variant.digitals.count.should == 1
    variant.destroy
    expect { Spree::Digital.find(digital_id) }.to raise_error(ActiveRecord::RecordNotFound)
  end
end