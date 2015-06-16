module Spree
  class DigitalConfiguration < Preferences::Configuration
    # number of times a customer can download a digital file
    preference :authorized_clicks,  :integer, :default => 3
    
    # number of days after initial purchase the customer can download a file
    preference :authorized_days,    :integer, :default => 2

    # should digitals be kept around after the associated product is destroyed
    preference :keep_digitals,      :boolean, :default => false

    #number of seconds before an s3 link expires
    preference :s3_expiration_seconds,    :integer, :default => 10

    #should links expire (if set to false authorized_clicks and authorized_days values are ignored)
    preference :expirable_links,    :boolean, :default => true

    #should require authentication for links downloading
    preference :authentication_required,    :boolean, :default => true

    #should require authorization (cancancan) for links downloading
    preference :authorization_required,    :boolean, :default => true

    #creates an individual download asset per user
    preference :per_user_attachment,    :boolean, :default => true

    #defines the proc to execute 
    def per_user_attachment_process
      @per_user_attachment_process
    end
    def per_user_attachment_process=(value)
      @per_user_attachment_process = value
    end
    
  end
end
