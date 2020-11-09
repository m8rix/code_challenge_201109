# frozen_string_literal: true

RSpec.shared_context 'bundler_helper' do
  def be_summary_for(bundles, with_price_from:)
    quantity = bundles.map { |bundle| bundle[:qty] * bundle[:size] }.sum

    bundle_results = bundles.map do |bundle|
      {
        quantity: bundle[:qty],
        size: bundle[:size],
        unit_price: with_price_from[bundle[:size]],
        total: bundle[:qty] * with_price_from[bundle[:size]]
      }
    end

    result ={
      quantity: quantity,
      format_code: 'SPEC',
      line_total_price: bundle_results.map { |bundle_result| bundle_result[:total] }.sum,
      bundles: bundle_results
    }

    eq(result)
  end

  def be_summary_text_for(bundles, with_price_from:)
    total = bundles.map { |bundle| (bundle[:qty] * with_price_from[bundle[:size]]).to_f }.sum
    quantity = bundles.map { |bundle| bundle[:qty] * bundle[:size] }.sum
    result = "#{quantity} SPEC $#{total}0\n"

    bundles.each do |bundle|
      result += "\t#{bundle[:qty]} x #{bundle[:size]} $#{(bundle[:qty] * with_price_from[bundle[:size]]).to_f}0\n"
    end

    eq(result)
  end

  def be_a_total_for(bundles, with_price_from:)
    result = bundles.map { |bundle| bundle[:qty] * with_price_from[bundle[:size]] }.sum

    eq(result)
  end

  def be_bundled_for(bundles, with_price_from:)
    result = bundles.map do |bundle|
      {
        quantity: bundle[:qty],
        size: bundle[:size],
        unit_price: with_price_from[bundle[:size]],
        total: bundle[:qty] * with_price_from[bundle[:size]]
      }
    end

    eq(result)
  end
end
