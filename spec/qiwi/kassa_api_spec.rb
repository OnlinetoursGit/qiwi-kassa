RSpec.describe Qiwi::Kassa::Api do
  let!(:site_id) { 'site-id' }
  let!(:bill_id) { '893794793973' }
  let!(:payment_id) { 'bb918d93-a3f6-4c89-b753-c9e2311f1318' }
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
        value: '2.00'
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
    before do
      refund_create_stub(url: Qiwi::Kassa::API_URL, site_id: site_id, payment_id: payment_id, refund_id: refund_id)
      refund_status_stub(url: Qiwi::Kassa::API_URL, site_id: site_id, payment_id: payment_id, refund_id: refund_id)
      refund_statuses_stub(url: Qiwi::Kassa::API_URL, site_id: site_id, payment_id: payment_id)
    end

    it '#create' do
      response = api_client.resources.refunds.create(site_id: site_id,
                                                     payment_id: payment_id,
                                                     refund_id: refund_id,
                                                     params: refund_params)

      expect(response['refundId']).to eq(refund_id)
      expect(response['amount']['value']).to eq(refund_params[:amount][:value])
      expect(response['status']['value']).to eq('COMPLETED')
      expect(response['flags']).to include('REVERSAL')
    end

    it '#status' do
      response = api_client.resources.refunds.status(site_id: site_id,
                                                     payment_id: payment_id,
                                                     refund_id: refund_id)

      expect(response['refundId']).to eq(refund_id)
      expect(response['amount']['value']).to eq(refund_params[:amount][:value])
      expect(response['status']['value']).to eq('COMPLETED')
      expect(response['flags']).to include('REVERSAL')
    end

    it '#statuses' do
      response = api_client.resources.refunds.statuses(site_id: site_id, payment_id: payment_id)

      expect(response[0]['refundId']).to eq(refund_id)
      expect(response[0]['amount']['value']).to eq(refund_params[:amount][:value])
      expect(response[0]['status']['value']).to eq('COMPLETED')
      expect(response[0]['flags']).to include('REVERSAL')
    end
  end

  describe 'captures resources' do
    let!(:capture_id) { 'capture-id' }

    before do
      capture_create_stub(url: Qiwi::Kassa::API_URL, site_id: site_id, payment_id: payment_id, capture_id: capture_id)
      capture_status_stub(url: Qiwi::Kassa::API_URL, site_id: site_id, payment_id: payment_id, capture_id: capture_id)
    end

    it '#create' do
      response = api_client.resources.captures.create(site_id: site_id, payment_id: payment_id, capture_id: capture_id)

      expect(response['captureId']).to eq(capture_id)
      expect(response['amount']['value']).to eq(bill_params[:amount][:value])
      expect(response['status']['value']).to eq('COMPLETED')
    end

    it '#status' do
      response = api_client.resources.captures.status(site_id: site_id, payment_id: payment_id, capture_id: capture_id)

      expect(response['captureId']).to eq(capture_id)
      expect(response['amount']['value']).to eq(bill_params[:amount][:value])
      expect(response['status']['value']).to eq('COMPLETED')
    end
  end
end
