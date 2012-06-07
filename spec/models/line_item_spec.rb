require File.dirname(__FILE__) + '/../spec_helper'

describe Spree::LineItem do

  context "#save" do
    it "should create one link for a single digital Variant" do
      digital_variant = FactoryGirl.create(:variant, :digital => FactoryGirl.create(:digital))
      line_item = FactoryGirl.create(:line_item, :variant => digital_variant)
      links = digital_variant.digital.digital_links
      links.all.size.should == 1
      links.first.line_item.should == line_item
    end

    it "should create a link for each quantity of a digital Variant, even when quantity changes later" do
      digital_variant = FactoryGirl.create(:variant, :digital => FactoryGirl.create(:digital))
      line_item = FactoryGirl.create(:line_item, :variant => digital_variant, :quantity => 5)
      links = digital_variant.digital.digital_links
      links.all.size.should == 5
      links.each { |link| link.line_item.should == line_item }
      
      # quantity update
      line_item.quantity = 8
      line_item.save
      links = digital_variant.digital.digital_links
      links.all.size.should == 8
      links.each { |link| link.line_item.should == line_item }
    end
  end
  
end




