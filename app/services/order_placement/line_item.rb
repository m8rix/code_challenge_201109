# frozen_string_literal: true

module OrderPlacement
  class LineItem
    attr_reader :quantity, :format_code

    def initialize(quantity, format_code)
      @quantity = quantity.to_i
      @format_code = format_code.upcase
    end
  end
end
