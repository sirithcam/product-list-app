RSpec.describe Tag do
  let(:params) { { title: 'test', products: [] } }

  it 'creates a new instance given a valid paramsibute' do
    Tag.create!(params)
  end

  it 'requires title' do
    tag = Tag.new(params.merge(title: ''))
    expect(tag).to_not be_valid
  end

  it 'rejects duplicate tag' do
    old_tag = create(:tag)
    tag_new = Tag.new(params.merge(title: old_tag.title))
    expect(tag_new).not_to be_valid
  end

  context 'products' do
    it 'has many products' do
      product1 = create(:product)
      product2 = create(:product)

      tag = Tag.create!(params.merge(products: [product1, product2]))
      expect(tag.products.count).to eq 2
    end
  end
end
