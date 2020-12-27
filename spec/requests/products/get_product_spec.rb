RSpec.describe 'GET /api/v1/products/:id', type: :request do
  let!(:product)  { create(:product) }
  let(:headers)   { { 'Accept': 'application/vnd.api+json' } }

  context 'existing product' do
    before { get api_v1_product_path(product), headers: headers }

    it 'returns id' do
      id = JSON.parse(response.body)['data']['id']
      expect(id).to eq product.id.to_s
    end

    it 'returns type' do
      type = JSON.parse(response.body)['data']['type']
      expect(type).to eq 'products'
    end

    it 'returns name' do
      name = JSON.parse(response.body)['data']['attributes']['name']
      expect(name).to eq product.name
    end

    it 'returns description' do
      description = JSON.parse(response.body)['data']['attributes']['description']
      expect(description).to eq product.description
    end

    # Fails because of bug that when price has 0 in decimal place (i.e. *.00), then one decimal place is missing
    it 'returns price' do
      price = JSON.parse(response.body)['data']['attributes']['price']
      expect(price).to eq format('%.2f', product.price)
    end

    it 'returns empty tags data' do
      tags_data = JSON.parse(response.body)['data']['relationships']['tags']['data']
      expect(tags_data).to be_empty
    end

    it 'returns tags data' do
      create_list(:tag, 20, products: [product])
      get api_v1_product_path(product), headers: headers

      tags_data = JSON.parse(response.body)['data']['relationships']['tags']['data']
      expect(tags_data.size).to eq 20
    end

    it 'returns Content-Type header' do
      expect(response.header['Content-Type']).to eq 'application/vnd.api+json; charset=utf-8'
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:ok)
    end

    context 'tag details' do
      let!(:tag) { create(:tag, products: [product]) }

      before { get api_v1_product_path(product), headers: headers }

      it 'returns id' do
        id = JSON.parse(response.body)['data']['relationships']['tags']['data'].first['id']
        expect(id).to eq tag.id.to_s
      end

      it 'returns type' do
        type = JSON.parse(response.body)['data']['relationships']['tags']['data'].first['type']
        expect(type).to eq 'tags'
      end
    end
  end

  context 'non-existing product' do
    before { get api_v1_product_path(2), headers: headers }

    it 'returns message' do
      message = JSON.parse(response.body)['message']
      expect(message).to eq 'Record Not Found!'
    end

    it 'returns Content-Type header' do
      expect(response.header['Content-Type']).to eq 'application/vnd.api+json; charset=utf-8'
    end

    it 'returns status code 404' do
      expect(response).to have_http_status(:not_found)
    end
  end
end
