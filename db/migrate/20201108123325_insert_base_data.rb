class InsertBaseData < ActiveRecord::Migration[6.0]
  def up
    SubmissionFormat.create(
      [
        {
          name: 'Image',
          code: 'IMG',
          bundles: [
            Bundle.new(size: 5, price: 450),
            Bundle.new(size: 10, price: 800)
          ]
        },
        {
          name: 'Audio',
          code: 'FLAC',
          bundles: [
            Bundle.new(size: 3, price: 427.50),
            Bundle.new(size: 6, price: 810),
            Bundle.new(size: 9, price: 1147.50)
          ]
        },
        {
          name: 'Video',
          code: 'VID',
          bundles: [
            Bundle.new(size: 3, price: 570),
            Bundle.new(size: 5, price: 900),
            Bundle.new(size: 9, price: 1530)
          ]
        }
      ]
    )
  end

  def down
    nil
  end
end
