RSpec.describe 'POST /api/v1/products', type: :request do
  let(:params) { { data: { type: 'products', attributes: attributes_for(:product) } } }
  let(:headers) { { 'Content-Type': 'application/vnd.api+json', 'Accept': 'application/vnd.api+json' } }

  context 'valid parameters' do
    before { post api_v1_products_path, params: params.to_json, headers: headers }

    it 'returns id' do
      id = JSON.parse(response.body)['data']['id']
      expect(id).to eq '1'
    end

    it 'returns type' do
      type = JSON.parse(response.body)['data']['type']
      expect(type).to eq params[:data][:type]
    end

    it 'returns name' do
      name = JSON.parse(response.body)['data']['attributes']['name']
      expect(name).to eq params[:data][:attributes][:name]
    end

    # Fails because of bug that when price has 0 in decimal place (i.e. *.00), then one decimal place is missing
    it 'returns price' do
      price = JSON.parse(response.body)['data']['attributes']['price']
      expect(price).to eq sprintf("%.2f", params[:data][:attributes][:price].to_s)
    end

    it 'returns description' do
      description = JSON.parse(response.body)['data']['attributes']['description']
      expect(description).to eq params[:data][:attributes][:description]
    end

    it 'returns empty tags data' do
      tags_data = JSON.parse(response.body)['data']['relationships']['tags']['data']
      expect(tags_data).to be_empty
    end

    it 'returns Content-Type header' do
      expect(response.header['Content-Type']).to eq 'application/vnd.api+json; charset=utf-8'
    end

    it 'returns status code 201' do
      expect(response).to have_http_status(201)
    end

    it 'creates product in database' do
      expect(Product.count).to eq 1
    end
  end

  describe 'invalid parameters' do
    context 'rejects empty name' do
      before do
        params[:data][:attributes].merge!(name: '')
        post api_v1_products_path, params: params.to_json, headers: headers
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
        expect(response).to have_http_status(422)
      end

      it 'does not create product in database' do
        expect(Product.count).to eq 0
      end
    end

    # Fails because of a bug that allows duplicate names
    context 'rejects duplicate name' do
      before do
        name = create(:product).name
        params[:data][:attributes].merge!(name: name) 
        post api_v1_products_path, params: params.to_json, headers: headers
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
        expect(response).to have_http_status(422)
      end 

      it 'does not create product in database' do
        expect(Product.count).to eq 1
      end
    end

    context 'rejects blank price' do
      before do
        params[:data][:attributes].merge!(price: ' ') 
        post api_v1_products_path, params: params.to_json, headers: headers
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
        expect(response).to have_http_status(422)
      end 

      it 'does not create product in database' do
        expect(Product.count).to eq 0
      end  
    end

    context 'rejects 0 price value' do
      before do
        params[:data][:attributes].merge!(price: 0) 
        post api_v1_products_path, params: params.to_json, headers: headers
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
        expect(response).to have_http_status(422)
      end 

      it 'does not create product in database' do
        expect(Product.count).to eq 0
      end   
    end

    context 'rejects negative price' do
      before do
        params[:data][:attributes].merge!(price: -20.22)
        post api_v1_products_path, params: params.to_json, headers: headers
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
        expect(response).to have_http_status(422)
      end 

      it 'does not create product in database' do
        expect(Product.count).to eq 0
      end   
    end

    context 'rejects string price' do
      before do
        params[:data][:attributes].merge!(price: 'test string')
        post api_v1_products_path, params: params.to_json, headers: headers
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
        expect(response).to have_http_status(422)
      end 

      it 'does not create product in database' do
        expect(Product.count).to eq 0
      end   
    end
  end
end
