require 'spree_core'
<<<<<<< HEAD

module SpreeDigital
  class Engine < Rails::Engine

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
=======
require 'spree_digital/engine'
>>>>>>> 9b919de... Modified to fit spree 0.70 extension
