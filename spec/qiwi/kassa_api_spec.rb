RSpec.describe Qiwi::Kassa::Api do
  let!(:bill_id) { '893794793973' }
  let!(:refund_id) { '899343443' }
  let!(:bill_params) {
    {
      amount: {
        currency: 'RUB',
        value: 100.00
      },
      comment: 'Text comment',
      expirationDateTime: '2018-04-13T14:30:00+03:00',
      customer: {},
      customFields: {}
    }
  }

  let!(:refund_params) {
    {
      amount: {
        currency: 'RUB',
        value: 50.50
      }
    }
  }

  let!(:api_client) { described_class.new(secret_key: 'skey') }

  before(:each) { stub_const('Qiwi::Kassa::API_URL', 'https://test.qiwi.com/') }

  describe 'bills resources' do
    before { bill_create_stub(url: Qiwi::Kassa::API_URL, id: bill_id) }
    before { bill_status_stub(url: Qiwi::Kassa::API_URL, id: bill_id) }
    before { bill_reject_stub(url: Qiwi::Kassa::API_URL, id: bill_id) }

    it '#create' do
      response = api_client.resources.bills.create(id: bill_id, params: bill_params)

      expect(response['billId']).to eq(bill_id)
      expect(response['amount']['value']).to eq(bill_params[:amount][:value])
      expect(response['status']['value']).to eq('WAITING')
    end

    it '#status' do
      response = api_client.resources.bills.status(id: bill_id)

      expect(response['billId']).to eq(bill_id)
      expect(response['amount']['value']).to eq(bill_params[:amount][:value])
      expect(response).to have_key('status')
    end

    it '#reject' do
      response = api_client.resources.bills.reject(id: bill_id)

      expect(response['billId']).to eq(bill_id)
      expect(response['amount']['value']).to eq(bill_params[:amount][:value])
      expect(response['status']['value']).to eq('REJECTED')
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
