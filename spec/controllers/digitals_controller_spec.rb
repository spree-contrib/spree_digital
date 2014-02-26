require 'spec_helper'

describe Spree::DigitalsController do
  context '#show' do
    let(:digital) { create(:digital) }
    let(:authorized_digital_link) { create(:digital_link, digital: digital) }

    it 'returns a 404 for a non-existent secret' do
      spree_get :show, secret: 'not_real'
      response.code.should eq('404')
    end

    it 'returns a 200 and calls send_file for link that is not a file' do
      controller.should_receive(:attachment_is_file?).and_return(false)
      controller.should_not_receive(:send_file)
      spree_get :show, secret: authorized_digital_link.secret
      response.code.should eq('200')
      response.should render_template(:unauthorized)
    end

    it 'returns a 200 and calls send_file for an authorized link that is a file' do
      controller.should_receive(:attachment_is_file?).and_return(true)
      controller.should_receive(:send_file).with(digital.attachment.path,
                                                 :filename => digital.attachment.original_filename,
                                                 :type => digital.attachment.content_type).
                                            and_return{controller.render :nothing => true,
                                                                         :content_type => digital.attachment.content_type }
      spree_get :show, secret: authorized_digital_link.secret
      response.code.should eq('200')
      response.header['Content-Type'].should match digital.attachment.content_type
    end

    it 'redirects to s3 for an authorized link when using s3' do
      Paperclip::Attachment.default_options[:storage] = :s3
      controller.should_receive(:redirect_to)
      controller.should_receive(:attachment_is_file?).and_return(true)
      controller.should_not_receive(:send_file)
      spree_get :show, secret: authorized_digital_link.secret
    end
  end
end
