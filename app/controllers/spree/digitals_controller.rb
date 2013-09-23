module Spree
  class DigitalsController < Spree::StoreController
    ssl_required :show
    rescue_from ActiveRecord::RecordNotFound, with: :resource_not_found

    def show
      link = DigitalLink.find_by_secret(params[:secret])

      if attachment.present? 

        # don't authorize the link unless the file exists
        # the logger error will help track down customer issues easier
        if attachment_is_file? 
          if digital_link.authorize!
            if Spree::Config[:use_s3]
              redirect_to attachment.expiring_url(Spree::DigitalConfiguration[:s3_expiration_seconds]) and return
            else
              send_file attachment.path, :filename => attachment.original_filename, :type => attachment.content_type and return
            end
          end

        else
          Rails.logger.error "Missing Digital Item: #{attachment.path}"
        end
      end

      render :unauthorized
    end


    private

    def attachment_is_file?
      return attachment.exists?
    end

    def digital_link
      @link ||= DigitalLink.find_by_secret(params[:secret])
      raise ActiveRecord::RecordNotFound if @link.nil?
      @link
    end

    def attachment
      @attachment ||= digital_link.digital.try(:attachment) if digital_link.present?
    end

    def resource_not_found
      head status: 404
    end

  end
end
