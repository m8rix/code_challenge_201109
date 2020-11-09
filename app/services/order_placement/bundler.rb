# frozen_string_literal: true

module OrderPlacement
  class Bundler
    attr_reader :order_quantity, :submission_format

    class UnresolvableQuantity < StandardError; end
    class NoSubmissionFormatFound < StandardError; end

    def initialize(order_quantity, submission_format)
      raise NoSubmissionFormatFound if submission_format.blank?
      @order_quantity = order_quantity
      @submission_format = submission_format
    end

    def summary
      {
        quantity: order_quantity,
        format_code: submission_format.code,
        line_total_price: total_price,
        bundles: derived_bundles
      }
    end

    def valid?
      derived_bundles.present?
    rescue OrderPlacement::Bundler::UnresolvableQuantity
      false
    end

    def text_summary
      # For demo purposes only
      message = "#{order_quantity} #{submission_format.code} $#{total_price}0\n"
      derived_bundles.each do |bundle|
        message += "\t#{bundle[:quantity]} x #{bundle[:size]} $#{bundle[:total]}0\n"
      end
      message
    end

    def total_price
      derived_bundles.map { |bundle| bundle[:total].to_f }.sum
    end

    def derived_bundles
      bundle_quantities.map do |bundle_size, bundle_quantity|
        {
          quantity: bundle_quantity,
          size: bundle_size,
          unit_price: bundle_options_by_size[bundle_size].price.to_f,
          total: bundle_options_by_size[bundle_size].price.to_f * bundle_quantity
        }
      end
    end

    private

    def bundle_option_sizes
      bundle_options_by_size.keys
    end

    def bundle_options_by_size
      submission_format.bundles.index_by(&:size)
    end

    def bundle_quantities
      @bundle_quantities ||= optimal_bundle_sizing
        .sort
        .reverse
        .group_by(&:itself)
        .transform_values(&:size)
    end

    # If number_of_bundles == 1 then we are checking if there is any bundle option that matches the line total exactly
    # If number_of_bundles == 2 then we are checking if there is any combination of 2 bundles that matche the line total exactly
    # And so on, up to the max number of bundles possible (the smallest bundle size divided by the ordered quantity)
    # performance is not great in that worst-case time complexity approaches very fast as the size of max_bundles increases
    # This would be the first refactor after getting the supporting logic in place
    def optimal_bundle_sizing(number_of_bundles = 1)
      raise UnresolvableQuantity if number_of_bundles > max_bundles

      bundle_arrangement(for_number_of_bundles: number_of_bundles) || optimal_bundle_sizing(number_of_bundles + 1)
    end

    def max_bundles
      order_quantity.to_i / bundle_option_sizes.min
    end

    # Of the bundle_option_sizes, check if there is a
    # valid bundle arrangement for given number_of_bundles
    # that would equal the order_quantity.
    # method responds with nil if there is no arrangement found
    # example:
    #   bundle_option_sizes = [5,3,9]
    #   number_of_bundles = 2
    #   order_quantity = 6
    #   output = [3,3]
    def bundle_arrangement(for_number_of_bundles:)
      (bundle_option_sizes * for_number_of_bundles)
        .combination(for_number_of_bundles)
        .to_a
        .map { |c| c.sort.reverse }
        .sort
        .uniq
        .reverse
        .find { |permutation| permutation.sum == order_quantity.to_i }
    end
  end
end
