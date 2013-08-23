require 'spec_helper'

describe Spree::Order do
  context "contents.add" do
    it "should add digital Variants of quantity 1 to an order" do
      order = create(:order)
      variants = 3.times.map { create(:variant, :digitals => [create(:digital)]) }
      variants.each { |v| order.contents.add(v, 1) }
      order.line_items.first.variant.should == variants[0]
      order.line_items.second.variant.should == variants[1]
      order.line_items.third.variant.should == variants[2]
    end
    
    it "should handle quantity higher than 1 when adding one specific digital Variant" do
      order = create(:order)
      digital_variant = create(:variant, :digitals => [create(:digital)])
      order.contents.add digital_variant, 3
      order.line_items.first.quantity.should == 3
      order.contents.add digital_variant, 2
      order.line_items.first.quantity.should == 5
    end
  end
  
  context "line_item analysis" do
    it "should understand that all products are digital" do
      order = create(:order)
      3.times do
        order.contents.add create(:variant, :digitals => [create(:digital)]), 1
      end
      order.digital?.should be_true
      order.contents.add create(:variant, :digitals => [create(:digital)]), 4
      order.digital?.should be_true
    end
    
    it "should understand that not all products are digital" do
      order = create(:order)
      3.times do
        order.contents.add create(:variant, :digitals => [create(:digital)]), 1
      end
      order.contents.add create(:variant), 1 # this is the analog product
      order.digital?.should be_false
      order.contents.add create(:variant, :digitals => [create(:digital)]), 4
      order.digital?.should be_false
    end
  end

  context '#digital?/#some_digital?' do
    let(:digital_order) {
      order = create(:order)
      variants = 3.times.map { create(:variant, :digitals => [create(:digital)]) }
      variants.each { |v| order.contents.add(v, 1) }
      order
    }

    let(:mixed_order) {
      order = create(:order)
      variants = 2.times.map { create(:variant, :digitals => [create(:digital)]) }
      variants << create(:variant)
      variants.each { |v| order.contents.add(v, 1) }
      order
    }

    let(:non_digital_order) {
      order = create(:order)
      variants = 3.times.map { create(:variant) }
      variants.each { |v| order.contents.add(v, 1) }
      order
    }

    it 'should return true/true for a digital order' do
      digital_order.should be_digital
      digital_order.should be_some_digital
    end

    it 'should return false/true for a mixed order' do
      mixed_order.should_not be_digital
      mixed_order.should be_some_digital
    end

    it 'should return false/false for an exclusively non-digital order' do
      non_digital_order.should_not be_digital
      non_digital_order.should_not be_some_digital
    end
  end

  context '#digital_line_items' do
    let(:digital_order_digitals) { 3.times.map { create(:digital) } }
    let(:digital_order) {
      order = create(:order)
      variants = digital_order_digitals.map { |d| create(:variant, :digitals => [d]) }
      variants.each { |v| order.contents.add(v, 1) }
      order
    }

    let(:mixed_order_digitals) { 2.times.map { create(:digital) } }
    let(:mixed_order) {
      order = create(:order)
      variants = mixed_order_digitals.map { |d| create(:variant, :digitals => [d]) }
      variants << create(:variant)
      variants.each { |v| order.contents.add(v, 1) }
      order
    }

    let(:non_digital_order) {
      order = create(:order)
      variants = 3.times.map { create(:variant) }
      variants.each { |v| order.contents.add(v, 1) }
      order
    }

    it 'should return true/true for a digital order' do
      digital_order_digital_line_items = digital_order.digital_line_items
      digital_order_digital_line_items.size.should eq(digital_order_digitals.size)
      variants = digital_order_digital_line_items.map(&:variant)
      variants.each do |variant|
        variant.should be_digital
      end
      digital_order_digitals.each do |d|
        variants.should include(d.variant)
      end
    end

    it 'should return false/true for a mixed order' do
      mixed_order_digital_line_items = mixed_order.digital_line_items
      mixed_order_digital_line_items.size.should eq(mixed_order_digitals.size)
      variants = mixed_order_digital_line_items.map(&:variant)
      variants.each do |variant|
        variant.should be_digital
      end
      mixed_order_digitals.each do |d|
        variants.should include(d.variant)
      end
    end

    it 'should return an empty set for an exclusively non-digital order' do
      non_digital_order_digital_line_items = non_digital_order.digital_line_items
      non_digital_order.digital_line_items.should be_empty
    end
  end

  context '#digital_links' do
    let(:mixed_order_digitals) { 2.times.map { create(:digital) } }
    let(:mixed_order) {
      order = create(:order)
      variants = mixed_order_digitals.map { |d| create(:variant, :digitals => [d]) }
      variants << create(:variant)
      variants.each { |v| order.contents.add(v, 1) }
      order
    }

    it 'correctly loads the links' do
      mixed_order_digital_links = mixed_order.digital_links
      links_from_digitals = mixed_order_digitals.map(&:reload).map(&:digital_links).flatten
      mixed_order_digital_links.size.should eq(links_from_digitals.size)
      mixed_order_digital_links.each do |l|
        links_from_digitals.should include(l)
      end
    end
  end

  context '#reset_digital_links!' do
    let!(:order) { build(:order) }
    let!(:link_1) { double }
    let!(:link_2) { double }

    before do
      link_1.should_receive(:reset!)
      link_2.should_receive(:reset!)
      order.should_receive(:digital_links).and_return([link_1, link_2])
    end

    it 'should call reset on the links' do
      order.reset_digital_links!
    end
  end
end
