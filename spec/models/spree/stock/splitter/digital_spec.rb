require 'spec_helper'

module Spree
  module Stock
    module Splitter
      describe Digital do

        let(:packer) { build(:stock_packer) }

        let(:item1) { create(:inventory_unit, variant: create(:digital).variant) }
        let(:item2) { create(:inventory_unit, variant: create(:variant)) }
        let(:item3) { create(:inventory_unit, variant: create(:variant)) }
        let(:item4) { create(:inventory_unit, variant: create(:digital).variant) }
        let(:item5) { create(:inventory_unit, variant: create(:digital).variant) }

        subject { Digital.new(packer) }

        it 'splits each package by product' do
          package1 = Package.new(packer.stock_location)
          package1.add item1, :on_hand
          package1.add item2, :on_hand
          package1.add item3, :on_hand
          package1.add item4, :on_hand
          package1.add item5, :on_hand

          packages = subject.split([package1])
          packages[0].quantity.should eq 3
          packages[1].quantity.should eq 2
        end
      end
    end
  end
end
