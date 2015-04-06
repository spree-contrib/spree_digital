require 'spec_helper'

describe Spree::Product do
  let(:product) { create(:product) }
  let(:digitals) { 3.times.map { create(:digital) } }
  let!(:variants) do
    digitals.map { |d| create(:variant, product: product, digitals: [d]) }
  end

  context 'digitals' do
    it 'returns the digitals from the variants' do
      product_digitals = product.digitals
      digitals.each { |d| expect(product_digitals).to include(d) }
    end 
  end
end