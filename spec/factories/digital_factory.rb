FactoryGirl.define do
  factory :digital, :class => Spree::Digital do |f|
    f.variant { |p| p.association(:variant) }

    attachment_content_type 'application/octet-stream'
    attachment_file_name "#{SecureRandom.hex(5)}.epub"
  end
end