require 'spec_helper'

describe Spree::Digital do

  context 'validation' do
    it { should belong_to(:variant) }
  end

  context "#create" do

  end
  
  context "#destroy" do
    it "should destroy associated digital_links" do
     digital = FactoryGirl.create(:digital)
     3.times { digital.digital_links.create!({ :line_item => FactoryGirl.create(:line_item) }, :without_protection => true) }
     Spree::DigitalLink.count.should == 3      
     digital.destroy
     Spree::DigitalLink.count.should == 0      
    end
  end
end

