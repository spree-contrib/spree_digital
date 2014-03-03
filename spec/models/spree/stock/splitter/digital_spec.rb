require 'spec_helper'

module Spree
  module Stock
    module Splitter
      describe Digital do

        let(:packer) { build(:stock_packer) }

        let(:line_item1) { create(:line_item, variant: create(:digital).variant) }
        let(:line_item2) { create(:line_item, variant: create(:variant)) }
        let(:line_item3) { create(:line_item, variant: create(:variant)) }
        let(:line_item4) { create(:line_item, variant: create(:digital).variant) }

        subject { Digital.new(packer) }

        it 'splits each package by product' do
          package1 = Package.new(packer.stock_location, packer.order)
          package1.add line_item1, 2, :on_hand
          package1.add line_item2, 3, :on_hand
          package1.add line_item3, 3, :on_hand
          package1.add line_item4, 2, :on_hand

          packages = subject.split([package1])
          packages[0].quantity.should eq 4
          packages[1].quantity.should eq 6
        end
      end
    end
  end
end
