RSpec.describe Product do
  let(:params) { { name: 'Product Name', price: 20, description: 'Lorem ipsum', tags: []  } }

  it 'creates a new instance given a valid attribute' do
    Product.create!(params)
  end

  it 'requires a name' do
    product = Product.new(params.merge(name: ' '))
    expect(product).to_not be_valid
  end
  
  it 'rejects duplicate product' do
    create(:product)

    product = Product.new(params)
    expect(product).to_not be_valid
  end

  it 'accept empty description' do
    Product.create!(params.merge(description: ''))
  end

  context 'price' do
    it 'requires a price' do
      product = Product.new(params.merge(price: ' '))
      expect(product).to_not be_valid
    end

    it 'rejects string price' do
      product = Product.new(params.merge(price: 'test'))
      expect(product).to_not be_valid
    end

    it 'rejects price value 0' do
      product = Product.new(params.merge(price: 0))
      expect(product).to_not be_valid
    end

    it 'rejects negative price' do
      product = Product.new(params.merge(price: -20))
      expect(product).to_not be_valid
    end
  end

  context 'tags' do
    it 'has many tags' do
      tags = create_list(:tag, 20)

      product = Product.create!(params.merge(tags: tags))
      expect(product.tags.size).to eq 20
    end

    it 'rejects duplicate tags' do
      tag1 = create(:tag)

      product = Product.new(params.merge(tags: [tag1, tag1]))
      expect(product).to_not be_valid
    end
  end
end
