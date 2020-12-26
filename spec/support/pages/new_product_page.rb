class NewProductPage
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  def visit_page
    visit new_product_path
  end

  def get_alert_message
    self.alert_element.text
  end

  def fill_in_with(params={})
    self.name_input.fill_in(with: params.fetch(:product_name))
    self.price_input.fill_in(with: params.fetch(:product_price))
    self.description_input.fill_in(with: params.fetch(:product_description))
  end

  def click_create_product
    self.create_product_button.click
  end

  private

  def alert_element
    find('#error_explanation')
  end

  def title_element
    find('h1')
  end

  def create_product_button
    find_button('Create Product')
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
end
