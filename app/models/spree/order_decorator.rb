module Spree
  module OrderDecorator
    def self.prepended(base)
      base.register_update_hook :generate_digital_links
    end

    # all products are digital
    def digital?
      line_items.all? { |item| item.digital? }
    end
    
    def some_digital?
      line_items.any? { |item| item.digital? }
    end

    def some_not_digital?
      line_items.any? { |item| !item.digital? }
    end

    alias :has_digital_line_items? :some_digital?
    alias :has_paper_line_items? :some_not_digital?
    
    def digital_line_items
      line_items.select(&:digital?)
    end

    def digital_links
      digital_line_items.map(&:digital_links).flatten
    end

    def reset_digital_links!
      digital_links.each do |digital_link|
        digital_link.reset!
      end
    end

    def generate_digital_links
      if self.complete?
        self.line_items.each{|a|a.create_digital_links} 
      end
    end
  end
end

::Spree::Order.prepend Spree::OrderDecorator if ::Spree::Order.included_modules.exclude?(Spree::OrderDecorator)
