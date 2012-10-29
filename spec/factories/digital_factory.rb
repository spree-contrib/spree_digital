FactoryGirl.define do
  factory :digital, :class => Spree::Digital do |f|
    # TODO good to assign variant association if no association is manually defined
    # f.variant { |p| p.association(:variant) }

    attachment_content_type 'application/octet-stream'
    attachment_file_name 'a_great_book.epub'
  end
end