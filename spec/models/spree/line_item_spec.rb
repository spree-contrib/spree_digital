require 'spec_helper'

RSpec.describe Spree::LineItem do
  context '#save' do
    it 'should create one link for a single digital Variant' do
      digital_variant = create(:variant, digitals: [create(:digital)])
      line_item = create(:line_item, variant: digital_variant)
      links = digital_variant.digitals.first.digital_links
      expect(links.to_a.size).to eq(1)
      expect(links.first.line_item).to eq(line_item)
    end

    it 'should create a link for each quantity of a digital Variant, even when quantity changes later' do
      digital_variant = create(:variant, digitals: [create(:digital)])
      line_item = create(:line_item, variant: digital_variant, quantity: 5)
      links = digital_variant.digitals.first.digital_links
      expect(links.to_a.size).to eq(5)
      links.each { |link| expect(link.line_item).to eq(line_item) }

      # quantity update
      line_item.quantity = 8
      line_item.save
      links = digital_variant.digitals.first.reload.digital_links
      expect(links.to_a.size).to eq(8)
      links.each { |link| expect(link.line_item).to eq(line_item) }
    end

    it 'should create a link for digital variants with multiple digital downloads attached' do
    end
  end

  context '#destroy' do
    it 'should destroy associated links when destroyed' do
      digital_variant = create(:variant, digitals: [create(:digital)])
      line_item = create(:line_item, variant: digital_variant)
      links = digital_variant.digitals.first.digital_links
      expect(links.to_a.size).to eq(1)
      expect(links.first.line_item).to eq(line_item)
      expect do
        line_item.destroy
      end.to change(Spree::DigitalLink, :count).by(-1)
    end
  end
end
