RSpec.feature 'New Product Page' do
  let(:new_product_page)  { NewProductPage.new }
  let(:edit_product_page) { EditProductPage.new }

  before { new_product_page.visit_page }

  scenario 'has title' do
    expect(new_product_page.title_element.text).to eq 'New Product'
  end

  scenario 'creates new product with valid values' do
    new_product_page.fill_in_with(product_name: 'Test123', product_price: '20', product_desc: 'test')   
    new_product_page.submit

    expect(edit_product_page.alert_element.text).to eq 'Product was successfully created.'
  end

  scenario '"Name can\'t be blank" alert is displayed' do
    new_product_page.fill_in_with(product_name: ' ', product_price: '20', product_desc: 'test')
    new_product_page.submit

    expect(new_product_page.alert_element.text).to include "Name can't be blank"
  end

  scenario '"Price can\'t be blank" alert is displayed' do
    new_product_page.fill_in_with(product_name: 'Test123', product_price: ' ', product_desc: 'test')
    new_product_page.submit

    expect(new_product_page.alert_element.text).to include "Price can't be blank"
  end

  scenario '"Price is not a number" alert is displayed' do
    new_product_page.fill_in_with(product_name: 'Test123', product_price: 'test', product_desc: 'test')
    new_product_page.submit

    expect(new_product_page.alert_element.text).to include "Price is not a number"
  end

  scenario '"Price must be greater than 0" alert is displayed' do
    new_product_page.fill_in_with(product_name: 'Test123', product_price: '0', product_desc: 'test')
    new_product_page.submit

    expect(new_product_page.alert_element.text).to include "Price must be greater than 0"
  end

  scenario '"Back" link redirects to Product Listing Page' do
    new_product_page.cancel

    expect(page.current_path).to eq products_path
  end
end
