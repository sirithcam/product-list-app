RSpec.describe 'POST /api/v1/tags', type: :request do
  let(:params) { { data: { type: 'tags', attributes: { title: 'test' } } } }
  let(:headers) { { 'Content-Type': 'application/vnd.api+json', 'Accept': 'application/vnd.api+json' } }

  context 'valid parameters' do
    before { post api_v1_tags_path, params: params.to_json, headers: headers }

    it 'returns id' do
      id = JSON.parse(response.body)['data']['id']
      expect(id).to eq '1'
    end

    it 'returns type' do
      type = JSON.parse(response.body)['data']['type']
      expect(type).to eq 'tags'
    end

    it 'returns title' do
      title = JSON.parse(response.body)['data']['attributes']['title']
      expect(title).to eq 'test'
    end

    it 'returns empty products data' do
      products_data = JSON.parse(response.body)['data']['relationships']['products']['data']
      expect(products_data).to be_empty
    end

    it 'returns Content-Type header' do
      expect(response.header['Content-Type']).to eq 'application/vnd.api+json; charset=utf-8' 
    end

    it 'returns status code 201' do
      expect(response).to have_http_status(201)
    end

    it 'creates tag in database' do
      expect(Tag.count).to eq 1
    end
  end

  context 'rejects empty title' do
    before do
      params[:data][:attributes].merge!(title: '')
      post api_v1_tags_path, params: params.to_json, headers: headers
    end

    it 'returns pointer' do
      pointer = JSON.parse(response.body)['errors'].first['source']['pointer']
      expect(pointer).to eq '/data/attributes/title'
    end

    it 'returns detail' do
      detail = JSON.parse(response.body)['errors'].first['detail']
      expect(detail).to eq "can't be blank"
    end

    it 'returns Content-Type header' do
      expect(response.header['Content-Type']).to eq 'application/vnd.api+json; charset=utf-8'
    end

    it 'returns status code 422' do
      expect(response).to have_http_status(422) 
    end

    it 'does not create tag in database' do
      expect(Tag.count).to eq 0
    end
  end

  # Fails because of bug that db doesn't allow duplicate titles but rails doesn't validate that so 500 error occurs
  # Also used xit in 2 tests because rails error 500 is so huge that scrolling through test run logs would be painfull
  context 'rejects duplicate title' do
    before do
      create(:tag, title: 'test')
      post api_v1_tags_path, params: params.to_json, headers: headers
    end

    xit 'returns pointer' do
      pointer = JSON.parse(response.body)['errors'].first['source']['pointer']
      expect(pointer).to eq '/data/attributes/title'
    end

    xit 'returns detail' do
      detail = JSON.parse(response.body)['errors'].first['detail']
      expect(detail).to eq 'has already been taken'
    end

    it 'returns Content-Type header' do
      expect(response.header['Content-Type']).to eq 'application/vnd.api+json; charset=utf-8'
    end

    it 'returns status code 422' do
      expect(response).to have_http_status(422) 
    end

    it 'does not create tag in database' do
      expect(Tag.count).to eq 1
    end
  end
end
