module Spree
  class DigitalsController < ApplicationController
    def show
      if attachment.present?
        if digital_link.authorize!
          if Rails.application.config.active_storage.service == :amazon
            redirect_to attachment.expiring_url(Spree::DigitalConfiguration[:s3_expiration_seconds]) and return
          else
            send_file(
              ActiveStorage::Blob.service.path_for(attachment.key),
              filename: attachment.record.attachment_file_name,
              type: attachment.record.attachment_content_type,
              status: :ok
            ) and return
          end
        end
      else
        Rails.logger.error 'Missing Digital Item: attachment'
      end

      render :unauthorized
    end

    private

    def digital_link
      @link ||= DigitalLink.find_by!(secret: params[:secret])
    end

    def attachment
      @attachment ||= digital_link.digital.try(:attachment) if digital_link.present?
    end
  end
end
