class NewProductPage
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  def visit_page
    visit new_product_path
    self
  end

  def fill_in_with(params={})
    fill_in 'product_name', with: params.fetch(:product_name)
    fill_in 'product_price', with: params.fetch(:product_price)
    fill_in 'product_description', with: params.fetch(:product_desc)

    self
  end

  def submit
    click_button 'Create Product'
  end

  def cancel
    click_link 'Back'
  end

  def alert_element
    find('#error_explanation')
  end

  def title_element
    find('h1')
  end
end
