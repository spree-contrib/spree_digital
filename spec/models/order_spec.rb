require File.dirname(__FILE__) + '/../spec_helper'

describe Spree::Order do

  context 'validation' do
    it { should have_valid_factory(:order) }
  end
  
  context "#add_variant" do
    it "should add digital Variants of quantity 1 to an order" do
      order = FactoryGirl.create(:order)
      order.add_variant variant1 = FactoryGirl.create(:variant, :digitals => [FactoryGirl.create(:digital)])
      order.add_variant variant2 = FactoryGirl.create(:variant, :digitals => [FactoryGirl.create(:digital)])
      order.add_variant variant3 = FactoryGirl.create(:variant, :digitals => [FactoryGirl.create(:digital)])
      order.line_items.first.variant.should == variant1
      order.line_items.second.variant.should == variant2
      order.line_items.third.variant.should == variant3
    end
    
    it "should handle quantity higher than 1 when adding one specific digital Variant" do
      order = FactoryGirl.create(:order)
      digital_variant = FactoryGirl.create(:variant, :digitals => [FactoryGirl.create(:digital)])
      order.add_variant digital_variant, 3
      order.line_items.first.quantity.should == 3
      order.add_variant digital_variant, 2
      order.line_items.first.quantity.should == 5
    end
  end
  
  context "line_item analysis" do
    it "should understand that all products are digital" do
      order = FactoryGirl.create(:order)
      3.times do
        order.add_variant FactoryGirl.create(:variant, :digitals => [FactoryGirl.create(:digital)])
      end
      order.digital?.should be_true
      order.add_variant FactoryGirl.create(:variant, :digitals => [FactoryGirl.create(:digital)]), 4
      order.digital?.should be_true
    end
    
    it "should understand that not all products are digital" do
      order = FactoryGirl.create(:order)
      3.times do
        order.add_variant FactoryGirl.create(:variant, :digitals => [FactoryGirl.create(:digital)])
      end
      order.add_variant FactoryGirl.create(:variant) # this is the analog product
      order.digital?.should be_false
      order.add_variant FactoryGirl.create(:variant, :digitals => [FactoryGirl.create(:digital)]), 4
      order.digital?.should be_false
    end
  end

  context "digital shipping" do
    before do
      @order = FactoryGirl.create(:order)
      # need shipp_address for rate_hash.count != 0
      @order.ship_address = FactoryGirl.create :address
      @order.bill_address = FactoryGirl.create :address
      @order.save!

      3.times { @order.add_variant FactoryGirl.create(:variant, :digitals => [FactoryGirl.create(:digital)]) }

      FactoryGirl.create :digital_shipping_method
      s = FactoryGirl.create :shipping_method
      s.calculator.set_preference(:amount, 10)
    end

    let(:order) { @order }

    it "should only offer digital shipping if all items are digital" do
      order.digital?.should be_true
      order.rate_hash.count.should == 1
      order.rate_hash.first.shipping_method.calculator.class.should == Spree::Calculator::DigitalDelivery
      order.rate_hash.first.cost.should == 0.0
    end

    it "should not offer digital shipping if only some items are digital" do
      order.digital?.should be_true
      order.add_variant FactoryGirl.create(:variant) # this is the analog product
      order.digital?.should be_false

      order.rate_hash.count.should == 1
      order.rate_hash.first.shipping_method.calculator.class.should_not == Spree::Calculator::DigitalDelivery
      puts "SHIPP #{order.rate_hash.first}"
      order.rate_hash.first.cost.should == 10.0
    end
  end
  
end

