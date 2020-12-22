RSpec.describe Product do
  it 'creates a new instance given a valid attribute' do
    create(:product)
  end

  it 'requires a name' do
    product = build(:product, name: ' ')
    expect(product).to_not be_valid
  end
  
  it 'cannot create duplicate product' do
    create(:product)

    product = build(:product)
    expect(product).to_not be_valid
  end

  it 'description is optional' do
    create(:product, description: '')
  end

  context 'price' do
    it 'requires a price' do
      product = build(:product, price: ' ')
      expect(product).to_not be_valid
    end

    it 'price cannot be string' do
      product = build(:product, price: 'test')
      expect(product).to_not be_valid
    end

    it 'price cannot be 0' do
      product = build(:product, price: 0)
      expect(product).to_not be_valid
    end

    it 'price cannot be negative' do
      product = build(:product, price: -20)
      expect(product).to_not be_valid
    end
  end

  context 'tags' do
    it 'has many tags' do
      tag1 = create(:tag)
      tag2 = create(:tag, title: generate(:title))

      product = create(:product, tags: [tag1, tag2])
      expect(product.tags.count).to eq 2
    end

    it 'cannot have duplicate tags' do
      tag1 = create(:tag)

      product = build(:product, tags: [tag1, tag1])
      expect(product).to_not be_valid
    end

    it 'product is not created when tag creation fails' do
      begin
        create(:product, tags = [ create(:tag, title: '') ])
      rescue ActiveRecord::RecordInvalid
        
      else
        raise 'Tag creation succeeded.'
      ensure
        expect(Product.all.count).to eq 0
      end
    end
  end
end
