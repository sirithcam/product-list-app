RSpec.describe 'GET /api/v1/products/:id', type: :request do
  let!(:product)  { create(:product) }
  let(:headers)   { { 'Accept': 'application/vnd.api+json' } }

  context 'existing product' do
    before { get api_v1_product_path(product), headers: headers }

    it 'returns id' do
      id = JSON.parse(response.body)['data']['id'].to_i
      expect(id).to eq product.id
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

    it 'returns price' do
      price = JSON.parse(response.body)['data']['attributes']['price'].to_f
      expect(price).to eq product.price.to_f
    end

    it 'returns empty tags data' do
      tags_data = JSON.parse(response.body)['data']['relationships']['tags']['data']
      expect(tags_data).to be_empty
    end

    it 'returns tags data' do
      20.times { create(:tag, products: [product]) }
      get api_v1_product_path(product), headers: headers

      tags_data = JSON.parse(response.body)['data']['relationships']['tags']['data']
      expect(tags_data.size).to eq 20
    end

    it 'returns Content-Type header' do
      expect(response.header['Content-Type']).to eq 'application/vnd.api+json; charset=utf-8'
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    context 'tag details' do
      let!(:tag) { create(:tag, products: [product] ) }

      before { get api_v1_product_path(product), headers: headers }

      it 'returns id' do
        id = JSON.parse(response.body)['data']['relationships']['tags']['data'].first['id'].to_i
        expect(id).to eq tag.id
      end

      it 'returns type' do
        type = JSON.parse(response.body)['data']['relationships']['tags']['data'].first['type']
        expect(type).to eq 'tags'
      end
    end
  end

  context 'non-existing product' do
    before { get api_v1_product_path(2), headers: headers }

    it 'returns message'  do  
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
