class Products::Create
  include Interactor::Initializer

  initialize_with :product_params

  def run
    Product.create(product_params.slice(:name, :description, :price))
  end
end
