# frozen_string_literal: true

RSpec.describe Qiwi::Kassa::Api do
  let!(:site_id) { 'site-id' }
  let!(:payment_id) { 'bb918d93-a3f6-4c89-b753-c9e2311f1318' }
  let!(:amount_value) { '10.00' }
  let!(:bill_params) do
    {
      amount: {
        currency: 'RUB',
        value: amount_value
      },
      comment: 'Text comment',
      expirationDateTime: '2023-03-29T14:12:45+03:00',
      customer: {},
      customFields: {}
    }
  end

  let(:provider) { :pay2me }
  let!(:api_client) { described_class.new(secret_key: 'skey', provider: provider) }

  before(:each) do
    stub_const('Qiwi::Kassa::API_HOSTS', { pay2me: 'https://test.pay2me.com' })
    stub_const('Qiwi::Kassa::Resource::BASIC_PATHS', { pay2me: 'payin/v1/sites' })
  end

  describe 'bills resources' do
    let!(:bill_id) { '893794793973' }

    before do
      bill_create_stub(provider: provider, id: bill_id, site_id: site_id)
      bill_status_stub(provider: provider, id: bill_id, site_id: site_id)
    end

    it '#create' do
      response = api_client.resources.bills.create(id: bill_id, site_id: site_id, params: bill_params)

      expect(response).to have_key('payUrl')
    end

    it '#status', :aggregate_failures do
      response = api_client.resources.bills.status(id: bill_id, site_id: site_id)

      expect(response).to have_key('paymentMethod')
      expect(response['status']['value']).to eq('COMPLETED')
    end

    context 'errors' do
      let!(:amount_value) { 3.0 }

      before do
        bill_create_with_validation_error_stub(provider: provider, id: bill_id, site_id: site_id)
      end
      it '#create responses with error', :aggregate_failures do
        response = api_client.resources.bills.create(id: bill_id, site_id: site_id, params: bill_params)

        expect(response['errorCode']).to eq(101003)
        expect(response['userMessage']).to eq('Internal error')
        expect(response['description']).to eq('INPUT DATA ERROR | `amount` request param value is incorrect')
      end
    end
  end
end
