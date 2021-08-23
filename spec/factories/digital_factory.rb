FactoryBot.define do
  factory :digital, class: Spree::Digital do |f|
    f.variant { |p| p.association(:variant) }

    attachment_content_type { 'application/octet-stream' }
    attachment_file_name    { "#{SecureRandom.hex(5)}.epub" }
    attachment_file_size    { 10 }

    after(:build) do |digital|
      digital.attachment.attach(
        io: StringIO.new(digital.attachment_content_type),
        filename: digital.attachment_file_name
      )
    end
  end
end
