class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :split_tags_params, only: [:update]

  # GET /products
  def index
    @products = Product.includes(:tags).take(10)
  end

  # GET /products/1
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product, notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /products/1
  def update
    @product = Products::Update.for(@product, product_params)
    if @product.errors.none?
      redirect_to @product, notice: 'Product was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
    redirect_to products_url, notice: 'Product was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Split tags param string to array
    def split_tags_params
      tags_param = params.dig(:product, :tags)
      if tags_param
        params[:product][:tags] = tags_param.split(' ')
      end
    end

    # Only allow a trusted parameter "white list" through.
    def product_params
      params.fetch(:product).permit(:name, :price, :description, tags: [])
    end
end
