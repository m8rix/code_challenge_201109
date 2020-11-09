# frozen_string_literal: true

RSpec.describe OrderPlacement::Inputs do
  describe ".line_items_from_string_input" do
    subject { described_class.line_items_from_string_input(input) }

    context "with valid and unique line items" do
      let(:input) { '10 img 15 FLAC 13 Vid' }

      it "should return typed line items" do
        is_expected.to contain_exactly(
          an_object_having_attributes(format_code: 'IMG',  quantity: 10),
          an_object_having_attributes(format_code: 'FLAC', quantity: 15),
          an_object_having_attributes(format_code: 'VID',  quantity: 13)
        )
      end
    end

    context "with valid and non-unique line items" do
      let(:input) { '10 IMG 15 FLAC 13 VID 5 IMG' }

      it "should group items listed twice" do
        is_expected.to contain_exactly(
          an_object_having_attributes(format_code: 'IMG',  quantity: 15),
          an_object_having_attributes(format_code: 'FLAC', quantity: 15),
          an_object_having_attributes(format_code: 'VID',  quantity: 13)
        )
      end
    end

    context "with invalid quantitiy" do
      let(:input) { 'TEN IMG' }

      it { expect { subject }.to raise_error(/TEN is not a valid quantity format/) }
    end

    context "with invalid format code" do
      let(:input) { '10 I-G' }

      it { expect { subject }.to raise_error(/I-G is not a valid code format/) }
    end
  end

  describe ".line_items_from_tuples_input" do
    subject { described_class.line_items_from_tuples_input(input) }

    context "with valid and unique line items" do
      let(:input) { [['10', 'img'], ['15', 'FLAC'], ['13', 'Vid']] }

      it "should return typed line items" do
        is_expected.to contain_exactly(
          an_object_having_attributes(format_code: 'IMG',  quantity: 10),
          an_object_having_attributes(format_code: 'FLAC', quantity: 15),
          an_object_having_attributes(format_code: 'VID',  quantity: 13)
        )
      end
    end

    context "with valid and non-unique line items" do
      let(:input) { [['10', 'img'], ['15', 'FLAC'], ['13', 'Vid'], ['5', 'IMG']] }

      it "should group items listed twice" do
        is_expected.to contain_exactly(
          an_object_having_attributes(format_code: 'IMG',  quantity: 15),
          an_object_having_attributes(format_code: 'FLAC', quantity: 15),
          an_object_having_attributes(format_code: 'VID',  quantity: 13)
        )
      end
    end

    context "with invalid quantitiy" do
      let(:input) { [['TEN', 'IMG']] }

      it { expect { subject }.to raise_error(/TEN is not a valid quantity format/) }
    end

    context "with invalid format code" do
      let(:input) { [['10', 'I-G']] }

      it { expect { subject }.to raise_error(/I-G is not a valid code format/) }
    end
  end
end
