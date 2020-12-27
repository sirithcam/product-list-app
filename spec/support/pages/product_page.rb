class ProductPage
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  def get_alert_message
    alert_element.text
  end

  def get_name
    name_element.text.gsub('Name: ', '')
  end

  def get_price
    price_element.text.gsub('Price: ', '')
  end

  def get_description
    description_element.text.gsub('Description: ', '')
  end

  def get_tags
    tags_element.text.gsub('Tags:', '').split(', ').map(&:strip)
  end

  private

  def alert_element
    find('#notice')
  end

  def name_element
    find('p', text: 'Name:')
  end

  def price_element
    find('p', text: 'Price:')
  end

  def description_element
    find('p', text: 'Description:')
  end

  def tags_element
    find('p', text: 'Tags:')
  end
end
