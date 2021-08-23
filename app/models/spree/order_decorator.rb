module Spree
  module OrderDecorator
    # all products are digital
    def digital?
      line_items.all?(&:digital?)
    end

    def some_digital?
      line_items.any?(&:digital?)
    end

    def digital_line_items
      line_items.select(&:digital?)
    end

    def digital_links
      digital_line_items.map(&:digital_links).flatten
    end

    def reset_digital_links!
      digital_links.each(&:reset!)
    end
  end
end

::Spree::Order.prepend(Spree::OrderDecorator)
