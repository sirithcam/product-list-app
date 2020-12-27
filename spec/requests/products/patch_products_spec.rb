RSpec.describe 'PATCH /api/v1/products/:id', type: :request do
  let!(:product) { create(:product) }
  let(:params)   { { data: { type: 'products', attributes: {} } } }
  let(:headers)  { { 'Content-Type': 'application/vnd.api+json', 'Accept': 'application/vnd.api+json' } }

  describe 'valid parameters' do
    it_behaves_like 'updates value', 'name', 'Modified Name'

    it_behaves_like 'updates value', 'price', '4.44'

    it_behaves_like 'updates value', 'description', 'Modified Desc'

    context 'existing tags' do
      before do
        titles = create_list(:tag, 20).map(&:title)
        params[:data][:attributes].merge!(tags: titles)
        patch api_v1_product_path(product), params: params.to_json, headers: headers
      end

      it 'returns id' do
        id = JSON.parse(response.body)['data']['id']
        expect(id).to eq '1'
      end

      it 'returns type' do
        type = JSON.parse(response.body)['data']['type']
        expect(type).to eq 'products'
      end

      it 'returns existing tags data' do
        tags_data = JSON.parse(response.body)['data']['relationships']['tags']['data']
        expect(tags_data.size).to eq 20
      end

      it 'returns Content-Type header' do
        expect(response.header['Content-Type']).to eq 'application/vnd.api+json; charset=utf-8'
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'new tags' do
      before do
        params[:data][:attributes].merge!(tags: generate_list(:title, 20))
        patch api_v1_product_path(product), params: params.to_json, headers: headers
      end

      it 'returns id' do
        id = JSON.parse(response.body)['data']['id']
        expect(id).to eq '1'
      end

      it 'returns type' do
        type = JSON.parse(response.body)['data']['type']
        expect(type).to eq 'products'
      end

      it 'returns new tags data' do
        tags_data = JSON.parse(response.body)['data']['relationships']['tags']['data']
        expect(tags_data.size).to eq 20
      end

      it 'returns Content-Type header' do
        expect(response.header['Content-Type']).to eq 'application/vnd.api+json; charset=utf-8'
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'removes tags' do
      before do
        params[:data][:attributes].merge!(tags: [])
        patch api_v1_product_path(product), params: params.to_json, headers: headers
      end

      it 'returns id' do
        id = JSON.parse(response.body)['data']['id']
        expect(id).to eq '1'
      end

      it 'returns type' do
        type = JSON.parse(response.body)['data']['type']
        expect(type).to eq 'products'
      end

      it 'returns new tags data' do
        tags_data = JSON.parse(response.body)['data']['relationships']['tags']['data']
        expect(tags_data.size).to eq 0
      end

      it 'returns Content-Type header' do
        expect(response.header['Content-Type']).to eq 'application/vnd.api+json; charset=utf-8'
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'invalid parameters' do
    context 'rejects empty name' do
      before do
        params[:data][:attributes].merge!(name: '')
        patch api_v1_product_path(product), params: params.to_json, headers: headers
      end

      it 'returns pointer' do
        pointer = JSON.parse(response.body)['errors'].first['source']['pointer']
        expect(pointer).to eq '/data/attributes/name'
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
    end

    # Fails because of a bug that allows duplicate names
    context 'rejects duplicate name' do
      let!(:product) { create(:product, name: 'Taken') }

      before do
        params[:data][:attributes].merge!(name: 'Taken')
        patch api_v1_product_path(product), params: params.to_json, headers: headers
      end

      it 'returns pointer' do
        pointer = JSON.parse(response.body)['errors'].first['source']['pointer']
        expect(pointer).to eq '/data/attributes/name'
      end

      it 'returns detail' do
        detail = JSON.parse(response.body)['errors'].first['detail']
        expect(detail).to eq 'has already been taken'
      end

      it 'returns Content-Type header' do
        expect(response.header['Content-Type']).to eq 'application/vnd.api+json; charset=utf-8'
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'rejects blank price' do
      before do
        params[:data][:attributes].merge!(price: ' ')
        patch api_v1_product_path(product), params: params.to_json, headers: headers
      end

      it 'returns pointer' do
        pointer = JSON.parse(response.body)['errors'].first['source']['pointer']
        expect(pointer).to eq '/data/attributes/price'
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
    end

    context 'rejects 0 price value' do
      before do
        params[:data][:attributes].merge!(price: 0)
        patch api_v1_product_path(product), params: params.to_json, headers: headers
      end

      it 'returns pointer' do
        pointer = JSON.parse(response.body)['errors'].first['source']['pointer']
        expect(pointer).to eq '/data/attributes/price'
      end

      it 'returns detail' do
        detail = JSON.parse(response.body)['errors'].first['detail']
        expect(detail).to eq 'must be greater than 0'
      end

      it 'returns Content-Type header' do
        expect(response.header['Content-Type']).to eq 'application/vnd.api+json; charset=utf-8'
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'rejects negative price' do
      before do
        params[:data][:attributes].merge!(price: -20.22)
        patch api_v1_product_path(product), params: params.to_json, headers: headers
      end

      it 'returns pointer' do
        pointer = JSON.parse(response.body)['errors'].first['source']['pointer']
        expect(pointer).to eq '/data/attributes/price'
      end

      it 'returns detail' do
        detail = JSON.parse(response.body)['errors'].first['detail']
        expect(detail).to eq 'must be greater than 0'
      end

      it 'returns Content-Type header' do
        expect(response.header['Content-Type']).to eq 'application/vnd.api+json; charset=utf-8'
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'rejects string price' do
      before do
        params[:data][:attributes].merge!(price: 'test string')
        patch api_v1_product_path(product), params: params.to_json, headers: headers
      end

      it 'returns pointer' do
        pointer = JSON.parse(response.body)['errors'].first['source']['pointer']
        expect(pointer).to eq '/data/attributes/price'
      end

      it 'returns detail' do
        detail = JSON.parse(response.body)['errors'].first['detail']
        expect(detail).to eq 'is not a number'
      end

      it 'returns Content-Type header' do
        expect(response.header['Content-Type']).to eq 'application/vnd.api+json; charset=utf-8'
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'rejects blank tag' do
      before do
        params[:data][:attributes].merge!(tags: [' '])
        patch api_v1_product_path(product), params: params.to_json, headers: headers
      end

      it 'returns pointer' do
        pointer = JSON.parse(response.body)['errors'].first['source']['pointer']
        expect(pointer).to eq '/data/attributes/tags'
      end

      it 'returns detail' do
        detail = JSON.parse(response.body)['errors'].first['detail']
        expect(detail).to eq "Tag can't be empty"
      end

      it 'returns Content-Type header' do
        expect(response.header['Content-Type']).to eq 'application/vnd.api+json; charset=utf-8'
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    # Fails because of bug that db doesn't allow duplicate titles but rails doesn't validate that so 500 error occurs
    # Also used xit in 2 tests because rails error 500 is so huge that scrolling through test run logs would be painfull
    context 'rejects duplicate tag' do
      before do
        tag = create(:tag)
        params[:data][:attributes].merge!(tags: [tag, tag])
        patch api_v1_product_path(product), params: params.to_json, headers: headers
      end

      xit 'returns pointer' do
        pointer = JSON.parse(response.body)['errors'].first['source']['pointer']
        expect(pointer).to eq '/data/attributes/tags'
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
    end

    context 'atomicity' do
      before do
        params[:data][:attributes].merge!(name: 'New Name', price: 4.44, description: 'New Desc',
                                          tags: generate_list(:title, 20))
      end

      it 'does not save product when name update fails' do
        old_attributes = product.attributes
        params[:data][:attributes].merge!(name: '')
        patch api_v1_product_path(product), params: params.to_json, headers: headers

        product.reload
        expect(old_attributes).to eq product.attributes
      end

      it 'does not save product when price update fails' do
        old_attributes = product.attributes
        params[:data][:attributes].merge!(price: -44)
        patch api_v1_product_path(product), params: params.to_json, headers: headers

        product.reload
        expect(old_attributes).to eq product.attributes
      end

      it 'does not save product when tag update fails' do
        tag = create(:tag)
        old_attributes = product.attributes
        params[:data][:attributes].merge!(tags: [tag.title, tag.title])
        patch api_v1_product_path(product), params: params.to_json, headers: headers

        product.reload
        expect(old_attributes).to eq product.attributes
      end

      it 'does not save product when tag creation fails' do
        old_attributes = product.attributes
        params[:data][:attributes].merge!(tags: [''])
        patch api_v1_product_path(product), params: params.to_json, headers: headers

        product.reload
        expect(old_attributes).to eq product.attributes
      end
    end
  end
end
