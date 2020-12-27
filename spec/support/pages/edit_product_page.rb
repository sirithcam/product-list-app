class EditProductPage
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  def visit_page(product)
    visit edit_product_path(product)
  end

  def get_alert_message
    alert_element.text
  end

  def get_name
    name_input.value
  end

  def get_price
    price_input.value
  end

  def get_description
    description_input.value
  end

  def get_tags
    tags_input.value
  end

  def fill_in_with(params = {})
    name_input.fill_in(with: params[:product_name]) unless params[:product_name].nil?
    price_input.fill_in(with: params[:product_price]) unless params[:product_price].nil?
    description_input.fill_in(with: params[:product_description]) unless params[:product_description].nil?
    tags_input.fill_in(with: params[:product_tags]) unless params[:product_tags].nil?
  end

  def click_update_product
    create_product_button.click
  end

  private

  def alert_element
    find('#error_explanation')
  end

  def title_element
    find('h1')
  end

  def create_product_button
    find_button('Update Product')
  end

  def name_input
    find('#product_name')
  end

  def price_input
    find('#product_price')
  end

  def description_input
    find('#product_description')
  end

  def tags_input
    find('#product_tags')
  end
end
