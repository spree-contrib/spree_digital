require File.dirname(__FILE__) + '/../spec_helper'

describe DigitalLink do

  context 'validation' do
    it { should belong_to(:digital) }
    it { should belong_to(:line_item) }
    it { should have_valid_factory(:digital_link) }
  end

  context "#create" do
    it "should have an appropriately long secret" do
      Factory(:digital_link).secret.length.should == 30
    end
    
    it "should have the access counter being an Integer on zero" do
      Factory(:digital_link).access_counter.should == 0
    end
  end
  
  context "#update" do
    it "should not change the secret when updated" do
      digital_link = Factory(:digital_link)
      secret = digital_link.secret
      digital_link.increment(:access_counter).save
      digital_link.secret.should == secret
    end
    
    it "should enforce to have an associated digital" do
      link = Factory(:digital_link)
      lambda { link.update_attributes!(:digital => nil) }.should raise_error(ActiveRecord::RecordInvalid)
    end

    it "should not allow an empty or too short secret" do
      link = Factory(:digital_link)
      lambda { link.update_attributes!(:secret => nil) }.should raise_error(ActiveRecord::RecordInvalid)
      lambda { link.update_attributes!(:secret => 'x' * 25) }.should raise_error(ActiveRecord::RecordInvalid)
    end
  end
  
  #context "authorization" do
  #  it "should increment the counter using #authorize!" do
  #    link = Factory(:digital_link)
  #    link.authorize!
  #    link.access_counter.should == 1
  #  end
  #  
  #  it "should not be #authorized? when the access_counter is too high" do
  #    link = Factory(:digital_link)
  #    link.stub(:access_counter => 2)
  #    link.authorized?.should be_true
  #    link.stub(:access_counter => 3)
  #    link.authorized?.should be_false
  #  end
  #  
  #  it "should not be #authorize! when the access_counter is too high" do
  #    link = Factory(:digital_link)
  #    link.stub(:access_counter => 2)
  #    link.authorize!.should be_true
  #    link.stub(:access_counter => 3)
  #    link.authorize!.should be_false
  #  end
  #  
  #  it "should not be #authorized? when the created_at date is too far in the past" do
  #    link = Factory(:digital_link)
  #    link.authorized?.should be_true
  #    link.stub(:created_at => 23.hours.ago)
  #    link.authorized?.should be_true
  #    link.stub(:created_at => 25.hours.ago)
  #    link.authorized?.should be_false
  #  end
  #  
  #  it "should not be #authorize! when the created_at date is too far in the past" do
  #    link = Factory(:digital_link)
  #    link.authorize!.should be_true
  #    link.stub(:created_at => 23.hours.ago)
  #    link.authorize!.should be_true
  #    link.stub(:created_at => 25.hours.ago)
  #    link.authorize!.should be_false
  #  end
  #  
  #  it "should not be #authorized? when both access_counter and created_at are invalid" do
  #    link = Factory(:digital_link)
  #    link.authorized?.should be_true
  #    link.stub(:access_counter => 3, :created_at => 25.hours.ago)
  #    link.authorized?.should be_false
  #  end
  #  
  #  it "should not be #authorize! when both access_counter and created_at are invalid" do
  #    link = Factory(:digital_link)
  #    link.authorize!.should be_true
  #    link.stub(:access_counter => 3, :created_at => 25.hours.ago)
  #    link.authorize!.should be_false
  #  end
  #end
  
end

