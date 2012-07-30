module Spree
  # authorized_clicks and authorized_days determine the validity of the link that is emailed
  # extended_download=true allows the user additional downloads if they are logged in
  # extended_click_limit sets a limit on the number of logged-in downloads to deter abuse
  class SpreeDigitalConfiguration < Preferences::Configuration
    preference :authorized_clicks,  :integer, :default => 3
    preference :authorized_days,    :integer, :default => 2
    preference :extended_download,   :boolean, :default => true
    preference :extended_click_limit,  :integer, :default => 15
  end
end