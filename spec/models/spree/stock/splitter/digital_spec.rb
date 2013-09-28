require 'spec_helper'

module Spree
  module Stock
    module Splitter
      describe Digital do

        let(:packer) { build(:stock_packer) }

        let(:variant1) { create(:digital).variant }
        let(:variant2) { create(:variant) }
        let(:variant3) { create(:variant) }
        let(:variant4) { create(:digital).variant }

        subject { Digital.new(packer) }

        it 'splits each package by product' do
          package1 = Package.new(packer.stock_location, packer.order)
          package1.add variant1, 2, :on_hand
          package1.add variant2, 3, :on_hand
          package1.add variant3, 3, :on_hand
          package1.add variant4, 2, :on_hand

          packages = subject.split([package1])
          packages[0].quantity.should eq 4
          packages[1].quantity.should eq 6
        end
      end
    end
  end
end
