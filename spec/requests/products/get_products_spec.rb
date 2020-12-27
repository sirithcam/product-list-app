RSpec.describe 'GET /api/v1/products', type: :request do
  let(:headers) { { 'Accept': 'application/vnd.api+json' } }

  context 'with one product' do
    let!(:tag)     { create(:tag) }
    let!(:product) { create(:product, tags: [tag]) }

    before { get api_v1_products_path, headers: headers }

    it 'returns id' do
      id = JSON.parse(response.body)['data'].first['id']
      expect(id).to eq product.id.to_s
    end

    it 'returns type' do
      type = JSON.parse(response.body)['data'].first['type']
      expect(type).to eq 'products'
    end

    it 'returns name' do
      name = JSON.parse(response.body)['data'].first['attributes']['name']
      expect(name).to eq product.name
    end

    # Fails because of bug that when price has 0 in decimal place (i.e. *.00), then one decimal place is missing
    it 'returns price' do
      price = JSON.parse(response.body)['data'].first['attributes']['price']
      expect(price).to eq sprintf("%.2f", product.price)
    end

    it 'returns description' do
      description = JSON.parse(response.body)['data'].first['attributes']['description']
      expect(description).to eq product.description
    end

    it 'returns Content-Type header' do
      expect(response.header['Content-Type']).to eq 'application/vnd.api+json; charset=utf-8'
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    context 'tag details' do
      it 'returns id' do
        id = JSON.parse(response.body)['data'].first['relationships']['tags']['data'].first['id']
        expect(id).to eq tag.id.to_s
      end

      it 'returns type' do
        type = JSON.parse(response.body)['data'].first['relationships']['tags']['data'].first['type']
        expect(type).to eq 'tags'
      end
    end
  end

  context 'with many products' do
    let!(:products) { create_list(:product, 20) }

    before { get api_v1_products_path, headers: headers }

    it 'returns all products' do
      expect(JSON.parse(response.body)['data'].size).to eq(20)
    end

    it 'returns Content-Type header' do
      expect(response.header['Content-Type']).to eq 'application/vnd.api+json; charset=utf-8'
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  context 'without products' do
    before { get api_v1_products_path, headers: headers }

    it 'returns empty data' do
      expect(JSON.parse(response.body)['data']).to be_empty
    end

    it 'returns Content-Type header' do
      expect(response.header['Content-Type']).to eq 'application/vnd.api+json; charset=utf-8'
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end 
  end
end
