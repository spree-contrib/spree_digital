require 'spec_helper'

describe Spree::Digital do

  context 'validation' do
    it { should belong_to(:variant) }
  end

  context "#create" do

  end
  
  context "#destroy" do
    it "should destroy associated digital_links" do
      digital = create(:digital)
      3.times { digital.digital_links.create!({ :line_item => create(:line_item) }) }
      Spree::DigitalLink.count.should == 3
      lambda {
        digital.destroy
      }.should change(Spree::DigitalLink, :count).by(-3)
    end
  end
end

