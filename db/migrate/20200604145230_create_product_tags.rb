class CreateProductTags < ActiveRecord::Migration[6.0]
  def change
    create_table :product_tags do |t|
      t.references :product, null: false
      t.references :tag, null: false
    end

    add_index :product_tags, [:product_id, :tag_id], unique: true
  end
end
