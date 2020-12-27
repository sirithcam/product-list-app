RSpec.describe Tags::Create do
  let(:title)   { generate(:title) }
  let(:product) { create(:product) }

  describe '.run method' do
    context 'valid attributes' do
      it 'returns created tag' do
        tag = described_class.run(title)
        expect(tag).to eq Tag.find_by_title(title)
      end
    end

    context 'invalid attributes' do
      it 'returns new not saved tag' do
        tag = described_class.run(' ')
        expect(tag.id).to be_nil
      end
    end
  end
end
