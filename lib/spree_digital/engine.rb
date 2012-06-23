module SpreeDigital
  class Engine < Rails::Engine
    engine_name 'spree_digital'

    config.autoload_paths += %W(#{config.root}/lib)

    initializer "spree.spree_digital.preferences", :after => "spree.environment" do |app|
      Spree::DigitalConfiguration = Spree::SpreeDigitalConfiguration.new
    end

    initializer "spree.register.digital_shipping", :after => 'spree.register.calculators' do |app|
      app.config.spree.calculators.shipping_methods << Spree::Calculator::DigitalDelivery
    end
   
    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
        Rails.application.config.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
