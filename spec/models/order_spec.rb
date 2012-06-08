require File.dirname(__FILE__) + '/../spec_helper'

describe Spree::Order do

  context 'validation' do
    it { should have_valid_factory(:order) }
  end
  
  context "#add_variant" do
    it "should add digital Variants of quantity 1 to an order" do
      order = FactoryGirl.create(:order)
      order.add_variant variant1 = FactoryGirl.create(:variant, :digital => FactoryGirl.create(:digital))
      order.add_variant variant2 = FactoryGirl.create(:variant, :digital => FactoryGirl.create(:digital))
      order.add_variant variant3 = FactoryGirl.create(:variant, :digital => FactoryGirl.create(:digital))
      order.line_items.first.variant.should == variant1
      order.line_items.second.variant.should == variant2
      order.line_items.third.variant.should == variant3
    end
    
    it "should handle quantity higher than 1 when adding one specific digital Variant" do
      order = FactoryGirl.create(:order)
      digital_variant = FactoryGirl.create(:variant, :digital => FactoryGirl.create(:digital))
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
        order.add_variant FactoryGirl.create(:variant, :digital => FactoryGirl.create(:digital))
      end
      order.digital?.should be_true
      order.add_variant FactoryGirl.create(:variant, :digital => FactoryGirl.create(:digital)), 4
      order.digital?.should be_true
    end
    
    it "should understand that not all products are digital" do
      order = FactoryGirl.create(:order)
      3.times do
        order.add_variant FactoryGirl.create(:variant, :digital => FactoryGirl.create(:digital))
      end
      order.add_variant FactoryGirl.create(:variant) # this is the analog product
      order.digital?.should be_false
      order.add_variant FactoryGirl.create(:variant, :digital => FactoryGirl.create(:digital)), 4
      order.digital?.should be_false
    end
  end
  
end

