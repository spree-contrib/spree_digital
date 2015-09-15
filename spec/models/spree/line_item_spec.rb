require 'spec_helper'

RSpec.describe Spree::LineItem do

  let!(:digital_variant) { create(:variant, :digitals => [create(:digital)]) }
  let!(:master_digital_variant) { create(:on_demand_master_variant, :digitals => [create(:digital)]) }
  let!(:line_item) { create(:line_item, :variant => digital_variant) }
  let!(:links) { digital_variant.digitals.first.digital_links }

  context "#digital?" do
    it "reports as digital if either the master variant or selected variant has digitals" do
      expect(create(:variant)).not_to be_digital
      expect(create(:on_demand_master_variant)).not_to be_digital

      expect(digital_variant).to be_digital
      expect(master_digital_variant).to be_digital
    end
  end

  context "#save" do
    it "should create one link for a single digital Variant" do
      links = digital_variant.digitals.first.digital_links
      expect(links.to_a.size).to eq(1)
      expect(links.first.line_item).to eq(line_item)
    end

    it "should create a link for each quantity of a digital Variant, even when quantity changes later" do
      # quantity update
      line_item.quantity = 8
      line_item.save
      links = digital_variant.digitals.first.reload.digital_links
      expect(links.to_a.size).to eq(8)
      links.each { |link| expect(link.line_item).to eq(line_item) }
    end

    it "should create a link for digital variants with multiple digital downloads attached" do

    end
  end

  context "#destroy" do
    it "should destroy associated links when destroyed" do
      expect(links.to_a.size).to eq(1)
      expect(links.first.line_item).to eq(line_item)
      expect {
        line_item.destroy
      }.to change(Spree::DigitalLink, :count).by(-1)
    end
  end
end




