require 'spec_helper'

RSpec.describe Spree::Variant do
  context '#destroy' do
    let(:variant) { create(:variant) }
    let!(:digital) { create(:digital, variant: variant) }

    it 'should destroy associated digitals by default' do
      # default is false
      Spree::DigitalConfiguration[:keep_digitals] = false
      expect(Spree::Digital.count).to eq(1)
      expect(variant.digitals.present?).to be true
      variant.deleted_at = Time.now
      expect(variant.deleted?).to be true
      variant.save!
      expect { digital.reload.present? }.to raise_error(ActiveRecord::RecordNotFound)
      expect(Spree::Digital.count).to eq(0)
    end

    it 'should conditionally keep associated digitals' do
      Spree::DigitalConfiguration[:keep_digitals] = true

      expect(Spree::Digital.count).to eq(1)
      expect(variant.digitals.present?).to be true
      variant.deleted_at = Time.now
      variant.save!
      expect(variant.deleted?).to be true
      expect { digital.reload.present? }.to_not raise_error
      expect(Spree::Digital.count).to eq(1)
    end
  end
end
