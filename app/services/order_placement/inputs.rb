# frozen_string_literal: true

module OrderPlacement
  class Inputs
    class StructureError < StandardError; end

  	class << self
      def line_items_from_string_input(order_string)
        line_items_from_tuples_input OrderTuples.from_string(order_string)
      end

      def line_items_from_tuples_input(order_tuples)
        validate_tuples_input(order_tuples)

        OrderTuples.unique_grouping(order_tuples).map { |item| LineItem.new(*item) }
      end

      private

      def validate_tuples_input(order_tuples)
        order_tuples.each do |qty, code|
          if qty.to_s.match(/\A[0-9]+\Z/).blank?
            raise StructureError, "#{qty} is not a valid quantity format"
          end

          if code.to_s.downcase.match(/\A[a-z]+\Z/).blank?
            raise StructureError, "#{code} is not a valid code format"
          end
        end
      end
    end
  end
end
