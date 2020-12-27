RSpec.describe Products::Update do
  let!(:product) { create(:product) }
  let(:tag)      { create(:tag) }
  let(:params)   { attributes_for(:product) }

  describe '.run method' do
    context 'valid attributes' do
      it 'returns updated product' do
        updated_product = Products::Update.run(product, params)
        expect(updated_product.name).to eq params[:name]
      end

      it 'returns updated product with tags' do
        updated_product = Products::Update.run(product, params.merge(tags: [tag]))
        expect(updated_product.tags.size).to eq 1
      end
    end

    context 'invalid attributes' do
      it 'returns product with error message' do
        updated_product = Products::Update.run(product, params.merge(name: ' '))
        expect(updated_product.errors.size).to eq 1
      end
    end
  end
end
