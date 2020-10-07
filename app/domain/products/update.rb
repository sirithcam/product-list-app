class Products::Update
  include Interactor::Initializer

  initialize_with :product, :product_params

  def run
    product.update!(tags ? product_params.merge(tags: tags) : product_params)
    product
  rescue ActiveRecord::RecordInvalid => e
    e.record.errors.each { |error| product.errors.add(:tags, error) } if e.record.is_a? Tag
    product
  end

  private

  def tags
    @tags ||= begin
      if product_params[:tags].is_a? Array
        product_params[:tags].map { |tag| Tag.find_by(title: tag) || Tags::Create.for(tag) }
      else
        []
      end
    end
  end
end
