RSpec.describe Qiwi::Kassa::Api do
  let!(:site_id) { 'site-id' }
  let!(:bill_id) { '893794793973' }
  let!(:refund_id) { '899343443' }
  let!(:bill_params) {
    {
      amount: {
        currency: 'RUB',
        value: '3.00'
      },
      comment: 'Text comment',
      expirationDateTime: '2023-03-29T14:12:45+03:00',
      customer: {},
      customFields: {}
    }
  }

  let!(:refund_params) {
    {
      amount: {
        currency: 'RUB',
        value: '1.50'
      }
    }
  }

  let!(:api_client) { described_class.new(secret_key: 'skey') }

  before(:each) { stub_const('Qiwi::Kassa::API_URL', 'https://test.qiwi.com/') }

  describe 'bills resources' do
    before { bill_create_stub(url: Qiwi::Kassa::API_URL, id: bill_id, site_id: site_id) }
    before { bill_status_stub(url: Qiwi::Kassa::API_URL, id: bill_id, site_id: site_id) }
    before { bill_payments_stub(url: Qiwi::Kassa::API_URL, id: bill_id, site_id: site_id) }

    it '#create' do
      response = api_client.resources.bills.create(id: bill_id, site_id: site_id, params: bill_params)

      expect(response['billId']).to eq(bill_id)
      expect(response['amount']['value']).to eq(bill_params[:amount][:value])
      expect(response['status']['value']).to eq('CREATED')
      expect(response).to have_key('payUrl')
    end

    it '#status' do
      response = api_client.resources.bills.status(id: bill_id, site_id: site_id)

      expect(response['billId']).to eq(bill_id)
      expect(response['amount']['value']).to eq(bill_params[:amount][:value])
      expect(response['status']['value']).to eq('PAID')
      expect(response).to have_key('payUrl')
      expect(response['payments'][0]['amount']['value']).to eq(bill_params[:amount][:value])
    end

    it '#payments' do
      response = api_client.resources.bills.payments(id: bill_id, site_id: site_id)

      expect(response[0]['billId']).to eq(bill_id)
      expect(response[0]['amount']['value']).to eq(bill_params[:amount][:value])
      expect(response[0]['status']['value']).to eq('COMPLETED')
    end
  end

  describe 'refunds resources' do
    before { refund_create_stub(url: Qiwi::Kassa::API_URL, bill_id: bill_id, refund_id: refund_id) }
    before { refund_status_stub(url: Qiwi::Kassa::API_URL, bill_id: bill_id, refund_id: refund_id) }

    it '#create' do
      response = api_client.resources.refunds.create(bill_id: bill_id,
                                                     refund_id: refund_id,
                                                     params: bill_params)

      expect(response['refundId']).to eq(refund_id)
      expect(response['amount']['value']).to eq(refund_params[:amount][:value])
      expect(response['status']).to eq('PARTIAL')
    end

    it '#status' do
      response = api_client.resources.refunds.status(bill_id: bill_id,
                                                     refund_id: refund_id)

      expect(response['refundId']).to eq(refund_id)
      expect(response['amount']['value']).to eq(refund_params[:amount][:value])
      expect(response['status']).to eq('PARTIAL')
    end
  end
end
