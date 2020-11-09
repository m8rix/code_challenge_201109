# frozen_string_literal: true

RSpec.describe OrderPlacement::Order do
  let(:instance) { described_class.new(line_items) }

  let(:line_items) { tuples.map { |item| double('LineItem', quantity: item.first, format_code: item.second) } }
  let(:tuples) { [[10, 'IMG'], [15, 'FLAC'], [13, 'VID']] }

  let(:submission_formats) do
    [
      SubmissionFormat.new(
        name: 'Image',
        code: 'IMG',
        bundles: [
          Bundle.new(size: 5, price: 450),
          Bundle.new(size: 10, price: 800)
        ]
      ),
      SubmissionFormat.new(
        name: 'Audio',
        code: 'FLAC',
        bundles: [
          Bundle.new(size: 3, price: 427.50),
          Bundle.new(size: 6, price: 810),
          Bundle.new(size: 9, price: 1147.50)
        ]
      ),
      SubmissionFormat.new(
        name: 'Video',
        code: 'VID',
        bundles: [
          Bundle.new(size: 3, price: 570),
          Bundle.new(size: 5, price: 900),
          Bundle.new(size: 9, price: 1530)
        ]
      )
    ].index_by(&:code)
  end

  before { allow(instance).to receive(:submission_formats).and_return(submission_formats) }

  describe ".text_summary_from_string_input" do
    subject { described_class.text_summary_from_string_input(input) }

    let(:input) { '10 img 15 FLAC 13 Vid' }

    context "when all bundles are valid" do
      before { allow_any_instance_of(described_class).to receive(:submission_formats).and_return(submission_formats) }

      it { is_expected.to eq "10 IMG $800.00\n\t1 x 10 $800.00\n15 FLAC $1957.50\n\t1 x 9 $1147.50\n\t1 x 6 $810.00\n13 VID $2370.00\n\t2 x 5 $1800.00\n\t1 x 3 $570.00\n" }
    end

    context "when format_code does not exist" do
      it { expect { subject }.to raise_error(OrderPlacement::Bundler::NoSubmissionFormatFound) }
    end
  end

  describe ".summary" do
    subject { instance.summary}

    it do
      is_expected.to eq [
        {
          bundles: [
            {
              quantity: 1,
              size: 10,
              total: 800.0,
              unit_price: 800.0
            }
          ],
          format_code: "IMG",
          line_total_price: 800.0,
          quantity: 10
        },
        {
          bundles: [
            {
              quantity: 1,
              size: 9,
              total: 1147.5,
              unit_price: 1147.5
            },
            {
              quantity: 1,
              size: 6,
              total: 810.0,
              unit_price: 810.0
            }
          ],
          format_code: "FLAC",
          line_total_price: 1957.5,
          quantity: 15
        },
        {
          bundles: [
            {
              quantity: 2,
              size: 5,
              total: 1800.0,
              unit_price: 900.0
            },
            {
              quantity: 1,
              size: 3,
              total: 570.0,
              unit_price: 570.0
            }
          ],
          format_code: "VID",
          line_total_price: 2370.0,
          quantity: 13
        }
      ]
    end
  end

  describe ".text_summary" do
    subject { instance.text_summary}

    it { is_expected.to eq "10 IMG $800.00\n\t1 x 10 $800.00\n15 FLAC $1957.50\n\t1 x 9 $1147.50\n\t1 x 6 $810.00\n13 VID $2370.00\n\t2 x 5 $1800.00\n\t1 x 3 $570.00\n" }
  end
end
