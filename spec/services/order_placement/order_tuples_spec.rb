# frozen_string_literal: true

RSpec.describe OrderPlacement::OrderTuples do
  describe ".from_string" do
    subject { described_class.from_string(input) }

    context "with valid string" do
      let(:input) { '10 IMG 15 FLAC 13 VID' }

      it { is_expected.to eq [['10', 'IMG'], ['15', 'FLAC'], ['13', 'VID']] }
    end

    context "with invalid string" do
      let(:input) { '10 IMG 15 FLAC 13 VID 23' }

      it { expect { subject }.to raise_error(/length of 7 can not be converted to a tuple/) }
    end
  end

  describe ".unique_grouping" do
    subject { described_class.unique_grouping(input) }

    context "with duplicate format codes" do
      let(:input) { [[1, 'IMG'], [1, 'IMG'], [1, 'IMG'], [1, 'VID']] }

      it { is_expected.to eq [[3, 'IMG'], [1, 'VID']] }
    end
  end
end
