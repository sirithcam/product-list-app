# 'product' and 'params' vars are taken from 'let' helper methods in the spec file

RSpec.shared_examples 'updates value' do |key, value|
  context key do
    before do
      params[:data][:attributes][key.to_sym] = value
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

    it "returns #{key}" do
      product.reload

      var = JSON.parse(response.body)['data']['attributes'][key]
      expect(var).to eq(product[key.to_sym].to_s).and eq value
    end 

    it 'returns empty tags data' do
      tags_data = JSON.parse(response.body)['data']['relationships']['tags']['data']
      expect(tags_data).to be_empty
    end

    it 'returns Content-Type header' do
      expect(response.header['Content-Type']).to eq 'application/vnd.api+json; charset=utf-8'
    end 

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
end
