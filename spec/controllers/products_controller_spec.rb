RSpec.describe ProductsController do
  include Capybara::DSL
  render_views

  describe "GET 'index'" do
    it 'allows access' do
      expect(response).to have_http_status(:ok)
    end

    context 'non-product related view' do
      before { get :index }

      it 'has title' do
        expect(response.body).to have_selector('h1', text: 'Products')
      end

      it 'has name column' do
        expect(response.body).to have_selector('thead tr th', text: 'Name')
      end

      it 'has price column' do
        expect(response.body).to have_selector('thead tr th', text: 'Price')
      end

      it 'has description column' do
        expect(response.body).to have_selector('thead tr th', text: 'Description')
      end

      it 'has tags column' do
        expect(response.body).to have_selector('thead tr th', text: 'Tags')
      end

      it 'has new product link' do
        expect(response.body).to have_selector("a[href='#{new_product_path}']", text: 'New Product')
      end
    end

    context 'product related view' do
      let!(:product) { create(:product) }
      let!(:tags)    { create_list(:tag, 20) }
      let(:products) { create_list(:product, 19) }

      before do
        product.update!(tags: tags)
        get :index
      end

      it 'has product name' do
        expect(response.body).to have_selector('tbody tr td', text: product.name)
      end

      # Fails because of bug that when price has 0 in decimal place (i.e. *.00), then one decimal place is missing
      it 'has product price' do
        expect(response.body).to have_selector('tbody tr td', text: format('%.2f', product.price))
      end

      it 'has product description' do
        expect(response.body).to have_selector('tbody tr td', text: product.description)
      end

      it 'has product tags' do
        tag_titles = product.tags.map(&:title).join(', ')
        expect(response.body).to have_selector('tbody tr td', text: tag_titles)
      end

      it 'has show link' do
        expect(response.body).to have_selector("a[href='#{product_path(product)}']", text: 'Show')
      end

      it 'has edit link' do
        expect(response.body).to have_selector("a[href='#{edit_product_path(product)}']", text: 'Edit')
      end

      it 'has destroy link' do
        expect(response.body).to have_selector("a[href='#{product_path(product)}'][data-method='delete']",
                                               text: 'Destroy')
      end

      # Fails because app does not support pagination, controller just selects 10 first entries from database
      it 'paginate products' do
        products
        get :index

        expect(response.body).to have_selector('tbody tr', count: 10)
        expect(response.body).to have_selector('span.disabled', text: 'Previous')
        expect(response.body).to have_selector("a[href='#{products_path}?page=2']", text: '2')
        expect(response.body).to have_selector("a[href='#{products_path}?page=2']", text: 'Next')
      end
    end
  end

  describe "GET 'show'" do
    let!(:tags)    { create_list(:tag, 20) }
    let!(:product) { create(:product, tags: tags) }

    before { get :show, params: { id: product } }

    it 'allows access' do
      expect(response).to have_http_status(:ok)
    end

    it 'has product name' do
      expect(response.body).to have_selector('p', text: product.name)
    end

    # Fails because of bug that when price has 0 in decimal place (i.e. *.00), then one decimal place is missing
    it 'has product price' do
      expect(response.body).to have_selector('p', text: format('%.2f', product.price))
    end

    it 'has product description' do
      expect(response.body).to have_selector('p', text: product.description)
    end

    it 'has product tags' do
      tag_titles = product.tags.map(&:title).join(', ')
      expect(response.body).to have_selector('p', text: tag_titles)
    end

    it 'has edit link' do
      expect(response.body).to have_selector("a[href='#{edit_product_path(product)}']", text: 'Edit')
    end

    it 'has back link' do
      expect(response.body).to have_selector("a[href='#{products_path}']", text: 'Back')
    end
  end

  describe "GET 'new'" do
    before { get :new }

    it 'allows access' do
      expect(response).to have_http_status(:ok)
    end

    it 'has title' do
      expect(response.body).to have_selector('h1', text: 'New Product')
    end

    it 'has back link' do
      expect(response.body).to have_selector("a[href='#{products_path}']", text: 'Back')
    end
  end

  describe "GET 'edit'" do
    let(:product) { create(:product) }

    before { get :edit, params: { id: product.id } }

    it 'allows access' do
      expect(response).to have_http_status(:ok)
    end

    it 'has title' do
      expect(response.body).to have_selector('h1', text: 'Editing Product')
    end

    it 'has show link' do
      expect(response.body).to have_selector("a[href='#{product_path(product)}']", text: 'Show')
    end

    it 'has back link' do
      expect(response.body).to have_selector("a[href='#{products_path}']", text: 'Back')
    end
  end

  describe "POST 'create'" do
    context 'with invalid attributes' do
      let(:params) { attributes_for(:product, name: ' ', price: ' ') }

      it "renders 'new' page" do
        post :create, params: { product: params }
        expect(response).to render_template('new')
      end

      it 'does not create new product' do
        expect { post :create, params: { product: params } }.not_to change(Product, :count)
      end
    end

    context 'with valid attributes' do
      let(:params) { attributes_for(:product) }

      it 'creates new user' do
        expect { post :create, params: { product: params } }.to change(Product, :count).by(1)
      end

      it 'redirects to product show page' do
        post :create, params: { product: params }
        expect(response).to redirect_to(product_path(assigns(:product)))
      end

      it 'has notice message' do
        post :create, params: { product: params }
        expect(flash[:notice]).to eq 'Product was successfully created.'
      end
    end
  end

  describe "PATCH 'update'" do
    let!(:product) { create(:product) }

    context 'with invalid attributes' do
      let(:params) { attributes_for(:product, name: ' ', price: ' ') }

      before { patch :update, params: { id: product.id, product: params } }

      it "renders 'edit' page" do
        expect(response).to render_template('edit')
      end

      it 'does not update product' do
        old_attributes = product.attributes
        product.reload
        expect(product.attributes).to eq old_attributes
      end
    end

    context 'with valid attributes' do
      let(:titles) { generate_list(:title, 20).join(' ') }
      let(:params) { attributes_for(:product, price: 4.44, description: 'Updated desc', tags: titles) }

      before { patch :update, params: { id: product.id, product: params } }

      it 'updates product' do
        product.reload
        aggregate_failures do
          expect(product.name).to eq params[:name]
          expect(product.price).to eq params[:price]
          expect(product.description).to eq params[:description]
          expect(product.tags.size).to eq 20
        end
      end

      it 'redirects to product show page' do
        expect(response).to redirect_to(product_path(product))
      end

      it 'has notice message' do
        expect(flash[:notice]).to eq 'Product was successfully updated.'
      end
    end
  end

  describe "DELETE 'destroy'" do
    let!(:product) { create(:product) }

    it 'deletes product' do
      expect { delete :destroy, params: { id: product.id } }.to change(Product, :count).by(-1)
    end

    it 'redirects to product index page' do
      delete :destroy, params: { id: product.id }
      expect(response).to redirect_to(products_path)
    end

    it 'has notice message' do
      delete :destroy, params: { id: product.id }
      expect(flash[:notice]).to eq 'Product was successfully destroyed.'
    end
  end
end
