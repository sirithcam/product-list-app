RSpec.feature 'New Product Page' do
  let(:new_product_page)  { NewProductPage.new }
  let(:product_page)      { ProductPage.new }

  before { new_product_page.visit_page }

  context 'valid parameters' do
    scenario 'User creates new product with valid values' do
      new_product_page.fill_in_with(product_name: generate(:name), product_price: '20', product_description: 'Lorem ipsum')   
      new_product_page.click_create_product

      expect(product_page.get_alert_message).to eq 'Product was successfully created.'
    end
  end

  context 'invalid parameters' do
    scenario 'User cannot create new product with duplicate name' do
      product = create(:product)

      new_product_page.fill_in_with(product_name: product.name, product_price: '20', product_description: 'Lorem ipsum')
      new_product_page.click_create_product

      expect(new_product_page.get_alert_message).to include 'Name has already been taken' 
    end

    scenario 'User cannot create new product with empty name' do
      new_product_page.fill_in_with(product_name: ' ', product_price: '20', product_description: 'Lorem ipsum')
      new_product_page.click_create_product

      expect(new_product_page.get_alert_message).to include "Name can't be blank"
    end

    scenario 'User cannot create new product with empty price' do
      new_product_page.fill_in_with(product_name: generate(:name), product_price: ' ', product_description: 'Lorem ipsum')
      new_product_page.click_create_product

      expect(new_product_page.get_alert_message).to include "Price can't be blank"
    end

    scenario 'User cannot create new product with string price' do
      new_product_page.fill_in_with(product_name: generate(:name), product_price: 'test string', product_description: 'Lorem ipsum')
      new_product_page.click_create_product
      expect(new_product_page.get_alert_message).to include "Price is not a number"
    end

    scenario 'User cannot create new product with 0 price value' do
      new_product_page.fill_in_with(product_name: generate(:name), product_price: '0', product_description: 'Lorem ipsum')
      new_product_page.click_create_product

      expect(new_product_page.get_alert_message).to include 'Price must be greater than 0'
    end

    scenario 'User cannot create new product with negative price' do
      new_product_page.fill_in_with(product_name: generate(:name), product_price: '-20', product_description: 'Lorem ipsum')
      new_product_page.click_create_product

      expect(new_product_page.get_alert_message).to include "Price must be greater than 0"
    end
  end
end
