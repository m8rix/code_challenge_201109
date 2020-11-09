class CreateBundles < ActiveRecord::Migration[6.0]
  def change
    create_table :bundles do |t|
      t.integer :size
      t.decimal :price, :precision => 8, :scale => 2
      t.references :submission_format, null: false, foreign_key: true

      t.timestamps
    end
  end
end
