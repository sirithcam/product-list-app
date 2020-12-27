RSpec.describe 'GET /api/v1/tags/:id', type: :request do
  let!(:tag)      { create(:tag) }
  let(:headers)   { { 'Accept': 'application/vnd.api+json' } }

  context 'existing tag' do
    before { get api_v1_tag_path(tag), headers: headers }

    it 'returns id' do
      id = JSON.parse(response.body)['data']['id']
      expect(id).to eq tag.id.to_s
    end

    it 'returns type' do
      type = JSON.parse(response.body)['data']['type']
      expect(type).to eq 'tags'
    end

    it 'returns title' do
      title = JSON.parse(response.body)['data']['attributes']['title']
      expect(title).to eq tag.title
    end

    it 'returns empty products data' do
      products_data = JSON.parse(response.body)['data']['relationships']['products']['data']
      expect(products_data).to be_empty
    end

    it 'returns products data' do
      20.times { create(:product, tags: [tag]) }
      get api_v1_tag_path(tag), headers: headers

      products_data = JSON.parse(response.body)['data']['relationships']['products']['data']
      expect(products_data.size).to eq 20
    end

    it 'returns Content-Type header' do
      expect(response.header['Content-Type']).to eq 'application/vnd.api+json; charset=utf-8'
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    context 'product details' do
      let!(:product) { create(:product, tags: [tag]) }

      before { get api_v1_tag_path(tag), headers: headers }

      it 'returns id' do
        id = JSON.parse(response.body)['data']['relationships']['products']['data'].first['id']
        expect(id).to eq product.id.to_s
      end

      it 'returns type' do
        type = JSON.parse(response.body)['data']['relationships']['products']['data'].first['type']
        expect(type).to eq 'products'
      end
    end
  end

  context 'non-existing tag' do
    before { get api_v1_tag_path(2), headers: headers }

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
