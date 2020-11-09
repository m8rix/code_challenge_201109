# frozen_string_literal: true

module OrderPlacement
  class Order
    attr_reader :line_items

    def initialize(line_items)
      @line_items = line_items
    end

    # puts OrderPlacement::Order.text_summary_from_string_input("10 img 15 FLAC 13 Vid")
    def self.text_summary_from_string_input(input)
      self.new(Inputs.line_items_from_string_input(input)).text_summary
    end

    def summary
      bundled_submission_formats.map(&:summary)
    end

    def valid?
      bundled_submission_formats.all?(&:valid?)
    end

    def text_summary
      bundled_submission_formats.map(&:text_summary).join
    end

    private

    def bundled_submission_formats
      @bundled_submission_formats = line_items.map do |line_item| 
        OrderPlacement::Bundler.new(
          line_item.quantity,
          submission_formats[line_item.format_code]
        )
      end
    end

    def submission_formats
      @submission_formats ||= SubmissionFormat.includes(:bundles).where(code: format_codes).index_by(&:code)
    end

    def format_codes
      line_items.map(&:format_code)
    end
  end
end
