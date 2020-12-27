RSpec.describe Product do
  let(:params) { attributes_for(:product) }
  let(:tags)   { create_list(:tag, 20) }
  
  describe 'attributes' do
    it 'has name' do
      expect(Product.new).to respond_to(:name)
    end

    it 'has price' do
      expect(Product.new).to respond_to(:price)
    end

    it 'has description' do
      expect(Product.new).to respond_to(:description)
    end

    it 'has tags' do
      expect(Product.new).to respond_to(:tags)
    end
  end

  describe 'create' do
    it 'creates new product given valid attributes' do
      expect { Product.create!(params) }.to change { Product.count }.by(1)
    end

    context 'tags' do
      it 'has many tags' do
        product = Product.create!(params.merge(tags: tags))
        expect(product.tags.size).to eq 20
      end
    end
  end

  describe 'validation' do
    it 'rejects empty name' do
      product = Product.new(params.merge(name: ' '))
      expect(product).not_to be_valid
    end

    it 'rejects duplicate name' do
      product = create(:product)
      new_product = Product.new(params.merge(name: product.name))
      expect(product).not_to be_valid
    end

    it 'rejects empty price' do
      product = Product.new(params.merge(price: ' '))
      expect(product).not_to be_valid
    end

    it 'rejects 0 price value' do
      product = Product.new(params.merge(price: 0))
      expect(product).not_to be_valid
    end
    
    it 'rejects negative price' do
      product = Product.new(params.merge(price: -20))
      expect(product).not_to be_valid
    end
    
    it 'rejects string price' do
      product = Product.new(params.merge(price: 'String Price'))
      expect(product).not_to be_valid
    end
  end

  describe 'update' do
    let!(:product) { create(:product) }
    
    it 'updates product name' do
      product.update!(name: 'New Name')
      expect(product.name).to eq 'New Name'
    end

    it 'updates product price' do
      product.update!(price: 44.44)
      expect(product.price.to_f).to eq 44.44 
    end

    it 'updates product description' do
      product.update!(description: 'New Desc')
      expect(product.description).to eq 'New Desc'
    end

    it 'updates product tags' do
      product.update!(tags: tags)
      expect(product.tags).to eq tags
    end
  end

  describe 'delete' do
    let!(:tag)     { create(:tag) }
    let!(:product) { create(:product, tags: [tag]) }

    it 'deletes product from database' do
      expect { Product.delete(product) }.to change { Product.count }.by(-1)
    end

    it 'does not delete related tag' do
      expect { Product.delete(product) }.not_to change { Tag.count }
    end
  end
end
