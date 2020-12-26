RSpec.feature 'Product Listing Page' do
  let!(:products)            { create_list(:product, 20) }
  let(:product_listing_page) { ProductListingPage.new }
  let(:product)              { products.first }

  before { visit product_listing_page.visit_page }

  scenario 'User deletes product' do
    accept_alert { product_listing_page.click_destroy_link(product.name) }

    aggregate_failures do
      expect(product_listing_page.get_alert_message).to eq 'Product was successfully destroyed.'
      expect(product_listing_page.has_product?(product.name)).to be false
    end
  end
end
