class EditProductPage
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  def visit_page(id)
    product = Product.find_by_id(id)
    visit edit_product_path(product)
    self
  end 

  def name
    find('p', text: 'Name').text.gsub('Name: ', '')
  end

  def price
    find('p', text: 'Price').text.gsub('Price: ', '')
  end

  def desc
    find('p', text: 'Description').text.gsub('Description: ', '')
  end

  def tags
    find('p', text: 'Tags').text.gsub('Tags: ', '').split(' ,')
  end

  def alert_element
    find('#notice')
  end
end
