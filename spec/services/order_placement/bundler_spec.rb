# frozen_string_literal: true

RSpec.describe OrderPlacement::Bundler do
  include_context 'bundler_helper'

  let(:instance) { described_class.new(order_quantity, submission_format) }

  let(:order_quantity) { 6 }
  let(:submission_format) { double('SubmissionFormat', name: 'Test', code: 'SPEC', bundles: bundles) }
  let(:bundles) { bundle_options.map { |size| double('Bundle', size: size, price: bundle_prices[size]) } }
  let(:bundle_prices) { Array.new(20).map { rand(1..50) } }

  describe ".summary" do
    subject { instance.summary }

    context "when minimum number of bundles fulfils ordered quantity" do
      let(:bundle_options) { [6, 7] }

      it { is_expected.to be_summary_for([{ qty: 1, size: 6 }], with_price_from: bundle_prices) }
    end

    context "when maximum number of bundles fulfils ordered quantity" do
      let(:bundle_options) { [1, 7] }

      it { is_expected.to be_summary_for([{ qty: 6, size: 1 }], with_price_from: bundle_prices) }
    end

    context "when there are multiple bundle arrangements possible" do
      let(:bundle_options) { [1, 2, 3] }

      # Other results would match an order_quantity of 6 such as [[3, 2, 1], [2, 2, 1, 1], [2, 1, 1, 1, 1], [1, 1, 1, 1, 1, 1]]
      # This test ensures we always give preference to the larger sized bundles i.e [3, 3]

      it { is_expected.to be_summary_for([{ qty: 2, size: 3 }], with_price_from: bundle_prices) }
    end

    context "when combining different bundle sizings" do
      let(:bundle_options) { [2, 4] }

      it { is_expected.to be_summary_for([{ qty: 1, size: 4 }, { qty: 1, size: 2 }], with_price_from: bundle_prices) }
    end

    context "when there are no possible bundle arrangements" do
      let(:bundle_options) { [5, 7] }

      it { expect { subject }.to raise_error(OrderPlacement::Bundler::UnresolvableQuantity) }
    end
  end

  describe ".text_summary" do
    subject { instance.text_summary }

    context "when minimum number of bundles fulfils ordered quantity" do
      let(:bundle_options) { [6, 7] }

      it { is_expected.to be_summary_text_for([{ qty: 1, size: 6 }], with_price_from: bundle_prices) }
    end

    context "when maximum number of bundles fulfils ordered quantity" do
      let(:bundle_options) { [1, 7] }

      it { is_expected.to be_summary_text_for([{ qty: 6, size: 1 }], with_price_from: bundle_prices) }
    end

    context "when there are multiple bundle arrangements possible" do
      let(:bundle_options) { [1, 2, 3] }

      # Other results would match an order_quantity of 6 such as [[3, 2, 1], [2, 2, 1, 1], [2, 1, 1, 1, 1], [1, 1, 1, 1, 1, 1]]
      # This test ensures we always give preference to the larger sized bundles i.e [3, 3]

      it { is_expected.to be_summary_text_for([{ qty: 2, size: 3 }], with_price_from: bundle_prices) }
    end

    context "when combining different bundle sizings" do
      let(:bundle_options) { [2, 4] }

      it { is_expected.to be_summary_text_for([{ qty: 1, size: 4 }, { qty: 1, size: 2 }], with_price_from: bundle_prices) }
    end

    context "when there are no possible bundle arrangements" do
      let(:bundle_options) { [5, 7] }

      it { expect { subject }.to raise_error(OrderPlacement::Bundler::UnresolvableQuantity) }
    end
  end

  describe ".valid?" do
    subject { instance.valid? }

    context "when minimum number of bundles fulfils ordered quantity" do
      let(:bundle_options) { [6, 7] }

      it { is_expected.to be_truthy }
    end

    context "when maximum number of bundles fulfils ordered quantity" do
      let(:bundle_options) { [1, 7] }

      it { is_expected.to be_truthy }
    end

    context "when there are multiple bundle arrangements possible" do
      let(:bundle_options) { [1, 2, 3] }

      it { is_expected.to be_truthy }
    end

    context "when combining different bundle sizings" do
      let(:bundle_options) { [2, 4] }

      it { is_expected.to be_truthy }
    end

    context "when there are no possible bundle arrangements" do
      let(:bundle_options) { [5, 7] }

      it { is_expected.to be_falsey }
    end
  end

  describe ".total_price" do
    subject { instance.send(:total_price) }

    context "when minimum number of bundles fulfils ordered quantity" do
      let(:bundle_options) { [6, 7] }

      it { is_expected.to be_a_total_for([{ qty: 1, size: 6 }], with_price_from: bundle_prices) }
    end

    context "when maximum number of bundles fulfils ordered quantity" do
      let(:bundle_options) { [1, 7] }

      it { is_expected.to be_a_total_for([{ qty: 6, size: 1 }], with_price_from: bundle_prices) }
    end

    context "when there are multiple bundle arrangements possible" do
      let(:bundle_options) { [1, 2, 3] }

      # Other results would match an order_quantity of 6 such as [[3, 2, 1], [2, 2, 1, 1], [2, 1, 1, 1, 1], [1, 1, 1, 1, 1, 1]]
      # This test ensures we always give preference to the larger sized bundles i.e [3, 3]

      it { is_expected.to be_a_total_for([{ qty: 2, size: 3 }], with_price_from: bundle_prices) }
    end

    context "when combining different bundle sizings" do
      let(:bundle_options) { [2, 4] }

      it { is_expected.to be_a_total_for([{ qty: 1, size: 4 }, { qty: 1, size: 2 }], with_price_from: bundle_prices) }
    end

    context "when there are no possible bundle arrangements" do
      let(:bundle_options) { [5, 7] }

      it { expect { subject }.to raise_error(OrderPlacement::Bundler::UnresolvableQuantity) }
    end
  end

  describe ".derived_bundles" do
    subject { instance.send(:derived_bundles) }

    context "when minimum number of bundles fulfils ordered quantity" do
      let(:bundle_options) { [6, 7] }

      it { is_expected.to be_bundled_for([{ qty: 1, size: 6 }], with_price_from: bundle_prices) }
    end

    context "when maximum number of bundles fulfils ordered quantity" do
      let(:bundle_options) { [1, 7] }

      it { is_expected.to be_bundled_for([{ qty: 6, size: 1 }], with_price_from: bundle_prices) }
    end

    context "when there are multiple bundle arrangements possible" do
      let(:bundle_options) { [1, 2, 3] }

      # Other results would match an order_quantity of 6 such as [[3, 2, 1], [2, 2, 1, 1], [2, 1, 1, 1, 1], [1, 1, 1, 1, 1, 1]]
      # This test ensures we always give preference to the larger sized bundles i.e [3, 3]

      it { is_expected.to be_bundled_for([{ qty: 2, size: 3 }], with_price_from: bundle_prices) }
    end

    context "when combining different bundle sizings" do
      let(:bundle_options) { [2, 4] }

      it { is_expected.to be_bundled_for([{ qty: 1, size: 4 }, { qty: 1, size: 2 }], with_price_from: bundle_prices) }
    end

    context "when there are no possible bundle arrangements" do
      let(:bundle_options) { [5, 7] }

      it { expect { subject }.to raise_error(OrderPlacement::Bundler::UnresolvableQuantity) }
    end
  end
end
