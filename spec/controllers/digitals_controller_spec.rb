require 'spec_helper'

RSpec.describe Spree::DigitalsController, :type => :controller do

  context '#show' do
    let(:digital) { create(:digital) }
    let(:authorized_digital_link) { create(:digital_link, digital: digital) }

    it 'returns a 404 for a non-existent secret' do
      spree_get :show, secret: 'NotReal00000000000000000000000'
      expect(response.status).to eq(404)
    end

    it 'returns a 200 and calls send_file for link that is not a file' do
      expect(controller).to receive(:attachment_is_file?).and_return(false)
      expect(controller).not_to receive(:send_file)
      spree_get :show, secret: authorized_digital_link.secret
      expect(response.status).to eq(200)
      expect(response).to render_template(:unauthorized)
    end

    it 'returns a 200 and calls send_file for an authorized link that is a file' do
      expect(controller).to receive(:attachment_is_file?).and_return(true)
      expect(controller).to receive(:send_file).with(digital.attachment.path,
                                                 :filename => digital.attachment.original_filename,
                                                 :type => digital.attachment.content_type){controller.render :nothing => true,
                                                                         :content_type => digital.attachment.content_type }
      spree_get :show, secret: authorized_digital_link.secret
      expect(response.status).to eq(200)
      expect(response.header['Content-Type']).to match digital.attachment.content_type
    end

    it 'redirects to s3 for an authorized link when using s3' do
      skip 'TODO: needs a way to test without having a bucket'
      Paperclip::Attachment.default_options[:storage] = :s3
      expect(controller).to receive(:redirect_to)
      expect(controller).to receive(:attachment_is_file?).and_return(true)
      expect(controller).not_to receive(:send_file)
      spree_get :show, secret: authorized_digital_link.secret
    end
  end
end
