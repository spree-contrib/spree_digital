require 'spec_helper'

describe Spree::DigitalLink do

  context 'validation' do
    it { should belong_to(:digital) }
    it { should belong_to(:line_item) }
  end

  context "#create" do
    it "should create an appropriately long secret" do
      create(:digital_link, secret: nil).secret.length.should == 30
    end
    
    it "should zero out the access counter on creation" do
      create(:digital_link, access_counter: nil).access_counter.should == 0
    end
  end
  
  context "#update" do
    it "should not change the secret when updated" do
      digital_link = create(:digital_link)
      secret = digital_link.secret
      digital_link.increment(:access_counter).save
      digital_link.secret.should == secret
    end
    
    it "should enforce to have an associated digital" do
      link = create(:digital_link)
      lambda { link.update_attributes!(:digital => nil) }.should raise_error(ActiveRecord::RecordInvalid)
    end

    it "should not allow an empty or too short secret" do
      link = create(:digital_link)
      lambda { link.update_attributes!(:secret => nil) }.should raise_error(ActiveRecord::RecordInvalid)
      lambda { link.update_attributes!(:secret => 'x' * 25) }.should raise_error(ActiveRecord::RecordInvalid)
    end
  end
  
  context "authorization" do
    it "should increment the counter using #authorize!" do
      link = create(:digital_link)
      link.access_counter.should == 0
      lambda {
        link.authorize!
      }.should change(link, :access_counter).by(1)
    end
   
   it "should not be #authorized? when the access_counter is too high" do
     link = create(:digital_link)
     link.stub(:access_counter => Spree::DigitalConfiguration[:authorized_clicks] - 1)
     link.authorizable?.should be_true
     link.stub(:access_counter => Spree::DigitalConfiguration[:authorized_clicks])
     link.authorizable?.should be_false
   end
      
   it "should not be #authorize! when the created_at date is too far in the past" do
     link = create(:digital_link)
     link.authorize!.should be_true
     link.stub(:created_at => (Spree::DigitalConfiguration[:authorized_days] * 24 - 1).hours.ago)
     link.authorize!.should be_true
     link.stub(:created_at => (Spree::DigitalConfiguration[:authorized_days] * 24 + 1).hours.ago)
     link.authorize!.should be_false
   end
   
   it "should not be #authorized? when both access_counter and created_at are invalid" do
     link = create(:digital_link)
     link.authorizable?.should be_true
     link.stub(:access_counter => Spree::DigitalConfiguration[:authorized_clicks], :created_at => (Spree::DigitalConfiguration[:authorized_days] * 24 + 1).hours.ago)
     link.authorizable?.should be_false
   end
   
  end

  context '#reset!' do
    it 'should reset the access counter' do
      link = create(:digital_link)
      link.authorize!
      link.access_counter.should eq(1)
      link.reset!
      link.access_counter.should eq(0)
    end
  end
end

