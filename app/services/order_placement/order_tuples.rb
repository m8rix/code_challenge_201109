# frozen_string_literal: true

module OrderPlacement
  class OrderTuples
    class NotDivisibleByTwo < StandardError; end

    class << self
      def from_string(string)
        raise NotDivisibleByTwo, "length of #{string.split.length} can not be converted to a tuple" unless string.split.length % 2 == 0
        string.split.in_groups_of(2, false)
      end

      def unique_grouping(arr)
        arr
          .map { |quantity, format_code| [quantity.to_i, format_code.to_s.upcase] }
          .group_by(&:last).transform_values { |item| item.map(&:first).sum }
          .map(&:reverse)
      end
    end
  end
end
