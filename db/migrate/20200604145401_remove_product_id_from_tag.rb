class RemoveProductIdFromTag < ActiveRecord::Migration[6.0]
  def change
    remove_column :tags, :product_id
    remove_index :tags, name: 'index_tags_on_product_id_and_title'
    add_index :tags, :title, unique: true
  end
end
