require File.dirname(__FILE__) + '/../spec_helper'

describe Spree::Digital do

  context 'validation' do
    it { should belong_to(:variant) }
    it { should have_valid_factory(:digital) }
  end

  context "#create" do

  end
  
  context "#destroy" do
    it "should destroy associated digital_links" do
     digital = FactoryGirl.create(:digital)
     3.times { digital.digital_links.create! }
     Spree::DigitalLink.count.should == 3      
     digital.destroy
     Spree::DigitalLink.count.should == 0      
    end
  end
end

