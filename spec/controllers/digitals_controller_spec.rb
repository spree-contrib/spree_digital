require 'spec_helper'

RSpec.describe Spree::DigitalsController, type: :controller do
  context '#show' do
    let(:digital) { create(:digital) }
    let(:authorized_digital_link) { create(:digital_link, digital: digital) }
    let(:expired_digital_link)    { create(:digital_link, created_at: 3.days.ago) }

    it 'returns a 404 for a non-existent secret' do
      expect do
        get :show, params: { secret: 'NotReal00000000000000000000000' }
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'returns a 200 and returns unauthorized when digital link is invalid' do
      expect(controller).not_to receive(:send_file)
      get :show, params: { secret: expired_digital_link.secret }
      expect(response.status).to eq(200)
      expect(response).to render_template(:unauthorized)
    end

    it 'returns a 200 and calls send_file for an authorized link that is a file' do
      expect(controller).to receive(:send_file).with(
        ActiveStorage::Blob.service.path_for(digital.attachment.key),
        filename: digital.attachment.record.attachment_file_name,
        type: digital.attachment.record.attachment_content_type,
        status: :ok
      ) {
        controller.head :ok,
                        content_type: digital.attachment.record.attachment_content_type,
                        status: :ok
      }
      get :show, params: { secret: authorized_digital_link.secret }
      expect(response.status).to eq(200)
      expect(response.header['Content-Type']).to match digital.attachment.record.attachment_content_type
    end

    it 'redirects to s3 for an authorized link when using s3' do
      skip 'TODO: needs a way to test without having a bucket'
      Paperclip::Attachment.default_options[:storage] = :s3
      expect(controller).to receive(:redirect_to)
      expect(controller).not_to receive(:send_file)
      get :show, params: { secret: authorized_digital_link.secret }
    end
  end
end
