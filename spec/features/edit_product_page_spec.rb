RSpec.feature 'Edit Product Page' do
  let!(:tags)             { create_list(:tag, 20) }
  let!(:product)          { create(:product, tags: tags) }
  let(:edit_product_page) { EditProductPage.new }
  let(:product_page)      { ProductPage.new }

  before { edit_product_page.visit_page(product) }

  describe 'valid parameters' do
    scenario 'User updates product name' do
      name = generate(:name)
      edit_product_page.fill_in_with(product_name: name)
      edit_product_page.click_update_product

      aggregate_failures do
        expect(product_page.get_alert_message).to eq 'Product was successfully updated.'
        expect(product_page.get_name).to eq name
      end
    end

    scenario 'User updates product price' do
      price = '4.44'
      edit_product_page.fill_in_with(product_price: price)
      edit_product_page.click_update_product

      aggregate_failures do
        expect(product_page.get_alert_message).to eq 'Product was successfully updated.'
        expect(product_page.get_price).to eq price
      end
    end

    scenario 'User updates product description' do
      description = 'Updated Description'
      edit_product_page.fill_in_with(product_description: description)
      edit_product_page.click_update_product

      aggregate_failures do
        expect(product_page.get_alert_message).to eq 'Product was successfully updated.'
        expect(product_page.get_description).to eq description
      end
      
    end

    context 'tags' do  
      let(:new_titles) { generate_list(:title, 20) }
      let(:tags2)      { create_list(:tag, 20) }

      scenario 'User updates product tags with existing tags' do
        titles = tags2.map{ |tag| tag.title }.join(' ')
        edit_product_page.fill_in_with(product_tags: titles)
        edit_product_page.click_update_product

        aggregate_failures do
          expect(product_page.get_alert_message).to eq 'Product was successfully updated.'
          expect(product_page.get_tags).to eq titles.split(' ')
          expect(product_page.get_tags.size).to eq tags2.size
        end
      end

      scenario 'User updates product tags with new tags' do
        edit_product_page.fill_in_with(product_tags: new_titles.join(' '))
        edit_product_page.click_update_product

        aggregate_failures do
          expect(product_page.get_alert_message).to eq 'Product was successfully updated.'
          expect(product_page.get_tags).to eq new_titles
          expect(product_page.get_tags.size).to eq new_titles.size
        end

      end

      scenario 'User appends new tags to existing product tags relationshp' do
        titles = "#{edit_product_page.get_tags} #{new_titles}"
        edit_product_page.fill_in_with(product_tags: titles)
        edit_product_page.click_update_product

        aggregate_failures do
          expect(product_page.get_alert_message).to eq 'Product was successfully updated.'
          expect(product_page.get_tags).to eq titles.split(' ')
          expect(product_page.get_tags.size).to eq (product.tags.size + new_titles.size)
        end
      end

      scenario 'User deletes one tag' do
        titles = edit_product_page.get_tags.gsub(" #{tags.last.title}", '')
        edit_product_page.fill_in_with(product_tags: titles)
        edit_product_page.click_update_product

        aggregate_failures do
          expect(product_page.get_alert_message).to eq 'Product was successfully updated.'
          expect(product_page.get_tags).to eq titles.split(' ')
          expect(product_page.get_tags.size).to eq 19
        end
      end

      scenario 'User deletes all tags' do
        edit_product_page.fill_in_with(product_tags: '')
        edit_product_page.click_update_product

        aggregate_failures do
          expect(product_page.get_alert_message).to eq 'Product was successfully updated.'
          expect(product_page.get_tags).to be_empty
        end
      end
    end
  end

  describe 'invalid parameters' do
    scenario 'User cannot update product with empty name' do
      edit_product_page.fill_in_with(product_name: ' ')
      edit_product_page.click_update_product

      expect(edit_product_page.get_alert_message).to include "Name can't be blank"
    end

    # Fails because of a bug that allows duplicate names
    scenario 'User cannot update product with duplicate name' do
      product2 = create(:product)
      edit_product_page.fill_in_with(product_name: product2.name)
      edit_product_page.click_update_product

      expect(edit_product_page.get_alert_message).to include 'Name has already been taken'
    end

    scenario 'User cannot update product with blank price' do
      edit_product_page.fill_in_with(product_price: ' ')
      edit_product_page.click_update_product

      expect(edit_product_page.get_alert_message).to include "Price can't be blank"
    end

    scenario 'User cannot update product with 0 price value' do
      edit_product_page.fill_in_with(product_price: 0)
      edit_product_page.click_update_product

      expect(edit_product_page.get_alert_message).to include 'Price must be greater than 0'
    end

    scenario 'User cannot update product with negative price' do
      edit_product_page.fill_in_with(product_price: -45) 
      edit_product_page.click_update_product

      expect(edit_product_page.get_alert_message).to include 'Price must be greater than 0'
    end 

    # Fails because of bug that db doesn't allow duplicate titles but rails doesn't validate that so 500 error occurs
    scenario 'User cannot update product with duplicate tag' do
      title = generate(:title)
      edit_product_page.fill_in_with(product_tags: "#{title} #{title}")

      expect(edit_product_page.get_alert_message).to include 'Tag has already been taken'
    end
  end
end
