module Spree
  class SpreeDigitalConfiguration < Preferences::Configuration
    # number of times a customer can download a digital file
    preference :authorized_clicks,  :integer, default: 3

    # number of days after initial purchase the customer can download a file
    preference :authorized_days,    :integer, default: 2

    # should digitals be kept around after the associated product is destroyed
    preference :keep_digitals,      :boolean, default: false

    # number of seconds before an s3 link expires
    preference :s3_expiration_seconds, :integer, default: 10
  end
end
