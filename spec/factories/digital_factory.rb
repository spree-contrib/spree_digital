FactoryGirl.define do
  factory :digital, :class => Spree::Digital do |f|
    f.variant { |p| p.association(:variant) }
    resource_url 'https://github.com/halo/spree_digital/archive/before-rails3-1.zip'

    attachment_content_type 'application/octet-stream'
    attachment_file_name "#{SecureRandom.hex(5)}.epub"
  end
end
