RSpec.describe 'DELETE /api/v1/product/:id', type: :request do
  let!(:tag)     { create(:tag) }
  let!(:product) { create(:product, tags: [tag]) }
  let(:headers)  { { 'Accept': 'application/vnd.api+json' } } 

  context 'existing product' do
    before { delete api_v1_product_path(product), headers: headers }

    it 'deletes product' do
      expect(Product.count).to eq 0
    end

    it 'does not delete tag' do
      expect(Tag.count).to eq 1
    end

    it 'returns empty body' do
      expect(response.body).to be_empty
    end

    it 'does not return Content-Type header' do
      expect(response.header['Content-Type']).to be_nil
    end

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end

  context 'non-existing product' do
    before { delete api_v1_product_path(2), headers: headers }

    it 'does not delete existing product' do
      expect(Product.count).to eq 1
    end

    it 'returns error message' do
      message = JSON.parse(response.body)['message']
      expect(message).to eq 'Record Not Found!'
    end 

    it 'returns Content-Type header' do
      expect(response.header['Content-Type']).to eq 'application/vnd.api+json; charset=utf-8'
    end 

    it 'returns status code 404' do
      expect(response).to have_http_status(404)
    end
  end
end
