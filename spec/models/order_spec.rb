require 'spec_helper'

describe Spree::Order do
  context "contents.add" do
    it "should add digital Variants of quantity 1 to an order" do
      order = FactoryGirl.create(:order)
      variants = 3.times.map { create(:variant, :digitals => [FactoryGirl.create(:digital)]) }
      variants.each { |v| order.contents.add(v, 1) }
      order.line_items.first.variant.should == variants[0]
      order.line_items.second.variant.should == variants[1]
      order.line_items.third.variant.should == variants[2]
    end
    
    it "should handle quantity higher than 1 when adding one specific digital Variant" do
      order = FactoryGirl.create(:order)
      digital_variant = FactoryGirl.create(:variant, :digitals => [FactoryGirl.create(:digital)])
      order.contents.add digital_variant, 3
      order.line_items.first.quantity.should == 3
      order.contents.add digital_variant, 2
      order.line_items.first.quantity.should == 5
    end
  end
  
  context "line_item analysis" do
    it "should understand that all products are digital" do
      order = FactoryGirl.create(:order)
      3.times do
        order.contents.add create(:variant, :digitals => [FactoryGirl.create(:digital)]), 1
      end
      order.digital?.should be_true
      order.contents.add FactoryGirl.create(:variant, :digitals => [FactoryGirl.create(:digital)]), 4
      order.digital?.should be_true
    end
    
    it "should understand that not all products are digital" do
      order = FactoryGirl.create(:order)
      3.times do
        order.contents.add FactoryGirl.create(:variant, :digitals => [FactoryGirl.create(:digital)]), 1
      end
      order.contents.add FactoryGirl.create(:variant), 1 # this is the analog product
      order.digital?.should be_false
      order.contents.add FactoryGirl.create(:variant, :digitals => [FactoryGirl.create(:digital)]), 4
      order.digital?.should be_false
    end
  end

end
