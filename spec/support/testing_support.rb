module SpreeDigital
  module TestingSupport
    module Helpers
      def image(filename)
        File.open(SpreeDigital::Engine.root + 'spec/fixtures' + filename)
      end

      def upload_image(filename)
        fixture_file_upload(image(filename).path)
      end
    end
  end
end
