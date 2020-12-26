class ProductListingPage
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  def visit_page
    visit products_path
  end

  def get_alert_message
    alert_element.text
  end

  def has_product?(product_name)
    has_product_element?(product_name)
  end

  def click_destroy_link(product_name)
    destroy_link(product_name).click
  end

  private

  def alert_element
    find('#notice')
  end

  def destroy_link(product_name)
    find('td', exact_text: product_name).find(:xpath, '..').find_link('Destroy')
  end

  def has_product_element?(product_name)
    page.has_css?('td', exact_text: product_name)
  end
end
