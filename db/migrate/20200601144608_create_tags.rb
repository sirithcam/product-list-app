class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.references :product, null: false
      t.string :title, null: false
    end

    add_index :tags, [:product_id, :title], unique: true
  end
end
