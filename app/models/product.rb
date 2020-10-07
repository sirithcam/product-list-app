class Product < ApplicationRecord
  has_many :product_tags, dependent: :destroy
  has_many :tags, through: :product_tags

  validates :name, :price, presence: true
  validates :price, numericality: { greater_than: 0 }
end
