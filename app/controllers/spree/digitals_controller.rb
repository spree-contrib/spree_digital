module Spree
  class DigitalsController < Spree::BaseController
    ssl_required :show
  
    def show
      link = DigitalLink.find_by_secret(params[:secret])

      if link.present? and link.digital.attachment.present?
        attachment = link.digital.attachment

        # don't authorize the link unless the file exists
        # the logger error will help track down customer issues easier

        if File.file?(attachment.path)
          if link.authorize!
            send_file attachment.path, :filename => attachment.original_filename, :type => attachment.content_type and return
          end
        else
          Rails.logger.error "Missing Digital Item: #{attachment.path}"
        end
      end
      
      render :unauthorized
    end
    
  end
end
