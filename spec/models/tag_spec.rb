RSpec.describe Tag do
  it 'creates a new instance given a valid attribute' do
    create(:tag)
  end

  it 'requires title' do
    tag = build(:tag, title: ' ')
    expect(tag).to_not be_valid
  end

  it 'cannot create duplicate tags' do
    create(:tag)
    tag = build(:tag)
    expect(tag).not_to be_valid
  end

  context 'products' do
    it 'has many products' do
      product1 = create(:product)
      product2 = create(:product, name: generate(:name))

      tag = create(:tag, products: [product1, product2])
      expect(tag.products.count).to eq 2
    end
  end
end
