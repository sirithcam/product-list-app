RSpec.describe 'GET /api/v1/tags', type: :request do
  let(:headers) { { 'Accept': 'application/vnd.api+json' } }

  context 'with one tag' do
    let!(:tag)     { create(:tag) }
    let!(:product) { create(:product, tags: [tag]) }

    before { get api_v1_tags_path, headers: headers }

    it 'returns id' do
      id = JSON.parse(response.body)['data'].first['id']
      expect(id).to eq tag.id.to_s
    end

    it 'returns type' do
      type = JSON.parse(response.body)['data'].first['type']
      expect(type).to eq 'tags'
    end

    it 'returns title' do
      title = JSON.parse(response.body)['data'].first['attributes']['title']
      expect(title).to eq tag.title
    end

    it 'returns Content-Type header' do
      expect(response.header['Content-Type']).to eq 'application/vnd.api+json; charset=utf-8'
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:ok)
    end

    context 'product details' do
      it 'returns id' do
        id = JSON.parse(response.body)['data'].first['relationships']['products']['data'].first['id']
        expect(id).to eq product.id.to_s
      end

      it 'returns type' do
        type = JSON.parse(response.body)['data'].first['relationships']['products']['data'].first['type']
        expect(type).to eq 'products'
      end
    end
  end

  context 'with many tags' do
    let!(:tags) { create_list(:tag, 20) }

    before { get api_v1_tags_path, headers: headers }

    it 'returns all tags' do
      expect(JSON.parse(response.body)['data'].size).to eq(20)
    end

    it 'returns Content-Type header' do
      expect(response.header['Content-Type']).to eq 'application/vnd.api+json; charset=utf-8'
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  context 'without tags' do
    before { get api_v1_tags_path, headers: headers }

    it 'returns empty data' do
      expect(JSON.parse(response.body)['data']).to be_empty
    end

    it 'returns Content-Type header' do
      expect(response.header['Content-Type']).to eq 'application/vnd.api+json; charset=utf-8'
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:ok)
    end
  end
end
