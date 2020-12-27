RSpec.describe Products::Create do
  let(:params) { attributes_for(:product) }
  let(:tag)    { create(:tag) }

  describe '.run method' do
    context 'valid attributes' do
      it 'returns created product' do
        product = Products::Create.run(params)
        expect(product).to eq Product.find_by_name(params[:name])
      end

      it 'doest not add tags when creating new product' do
        product = Products::Create.run(params.merge(tags: [tag]))
        expect(product.tags.size).to eq 0
      end
    end

    context 'invalid attributes' do
      it 'returns new not saved product' do
        product = Products::Create.run(params.merge(name: ' ', price: ' '))
        expect(product.id).to be_nil
      end
    end
  end
end
