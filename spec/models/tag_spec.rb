RSpec.describe Tag do
  let(:products) { create_list(:product, 20) }
  let(:params)   { attributes_for(:tag) }

  describe 'create' do
    it 'creates a new instance given a valid attributes' do
      expect { described_class.create!(params) }.to change(described_class, :count).by(1)
    end

    context 'products' do
      it 'has many products' do
        tag = described_class.create!(params.merge(products: products))
        expect(tag.products.size).to eq 20
      end
    end
  end

  describe 'validation' do
    it 'requires title' do
      tag = described_class.new(params.merge(title: ''))
      expect(tag).not_to be_valid
    end

    # Fails because of a bug that allows duplicate tags
    it 'rejects duplicate tag' do
      tag = create(:tag)
      new_tag = described_class.new(params.merge(title: tag.title))
      expect(new_tag).not_to be_valid
    end
  end

  describe 'update' do
    let!(:tag) { create(:tag) }

    it 'updates tag title' do
      tag.update!(title: 'new_title')
      expect(tag.title).to eq 'new_title'
    end

    it 'updates tag products' do
      tag.update!(products: products)
      expect(tag.products.size).to eq 20
    end
  end

  describe 'delete' do
    let!(:product) { create(:product) }
    let!(:tag)     { create(:tag, products: [product]) }

    it 'deletes tag from database' do
      expect { described_class.delete(tag) }.to change(described_class, :count).by(-1)
    end

    it 'does not delete related product' do
      expect { described_class.delete(tag) }.not_to change(Product, :count)
    end
  end
end
