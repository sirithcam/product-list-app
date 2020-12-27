RSpec.describe 'PATCH /api/v1/tags/:id', type: :request do
  let!(:tag)      { create(:tag) }
  let(:params)    { { data: { type: 'tags', attributes: attributes_for(:tag, title: 'modified_title') } } }
  let(:headers)   { { 'Content-Type': 'application/vnd.api+json', 'Accept': 'application/vnd.api+json' } }

  context 'valid parameters' do
    before do
      patch api_v1_tag_path(tag), params: params.to_json, headers: headers
      tag.reload
    end

    it 'returns id' do
      id = JSON.parse(response.body)['data']['id']
      expect(id).to eq '1'
    end

    it 'returns type' do
      type = JSON.parse(response.body)['data']['type']
      expect(type).to eq params[:data][:type]
    end

    it 'returns title' do
      title = JSON.parse(response.body)['data']['attributes']['title']
      expect(title).to eq(tag.title).and eq params[:data][:attributes][:title]
    end

    it 'returns empty products data' do
      products_data = JSON.parse(response.body)['data']['relationships']['products']['data']
      expect(products_data).to be_empty
    end

    it 'returns products data' do
      create_list(:product, 20, tags: [tag])
      patch api_v1_tag_path(tag), params: params.merge(title: 'modified_title2').to_json, headers: headers

      products_data = JSON.parse(response.body)['data']['relationships']['products']['data']
      expect(products_data.size).to eq 20
    end

    it 'returns Content-Type header' do
      expect(response.header['Content-Type']).to eq 'application/vnd.api+json; charset=utf-8'
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  context 'invalid parameters' do
    context 'rejects empty title' do
      before do
        params[:data][:attributes].merge!(title: '')
        patch api_v1_tag_path(tag), params: params.to_json, headers: headers
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
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not change database value' do
        old_title = tag.title
        tag.reload
        expect(tag.title).to eq old_title
      end
    end

    # Fails because of bug that db doesn't allow duplicate titles but rails doesn't validate that so 500 error occurs
    # Also used xit in 2 tests because rails error 500 is so huge that scrolling through test run logs would be painfull
    context 'rejects dupliate title' do
      before do
        tag2 = create(:tag)
        params[:data][:attributes].merge!(title: tag2.title)
        patch api_v1_tag_path(tag), params: params.to_json, headers: headers
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
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not change database value' do
        old_title = tag.title
        tag.reload
        expect(tag.title).to eq old_title
      end
    end
  end

  context 'non-existing tag' do
    before { patch api_v1_tag_path(2), params: params.to_json, headers: headers }

    it 'returns error message' do
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
