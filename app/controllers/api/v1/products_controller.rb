class Api::V1::ProductsController < Api::V1::ApplicationController
  def index
    render json: Product.includes(:tags).all
  end

  def show
    render json: Product.find(params[:id])
  end

  def create
    product = Products::Create.for(product_params)
    if product.persisted?
      render json: product, status: :created
    else
      render_validation_error(product)
    end
  end

  def update
    product = Products::Update.for(Product.find(params[:id]), product_params)
    if product.errors.none?
      render json: product
    else
      render_validation_error(product)
    end
  end

  def destroy
    product = Product.find(params[:id])
    product.destroy

    head :no_content
  end

  private

  def product_params
    @product_params ||= params.require(:data).require(:attributes).permit(
      :name, :description, :price, tags: []
    )
  end
end
