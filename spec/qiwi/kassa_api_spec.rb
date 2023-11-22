# frozen_string_literal: true

RSpec.describe Qiwi::Kassa::Api do
  let!(:site_id) { 'site-id' }
  let!(:payment_id) { 'bb918d93-a3f6-4c89-b753-c9e2311f1318' }
  let!(:amount_value) { '3.00' }
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
  let(:api_client) { described_class.new(secret_key: 'skey') }
  let!(:provider) { :qiwi }

  before do
    stub_const('Qiwi::Kassa::API_HOSTS', { qiwi: 'https://test.qiwi.com' })
  end

  describe 'bills resources' do
    let!(:bill_id) { '893794793973' }

    before do
      bill_create_stub(provider: provider, id: bill_id, site_id: site_id)
      bill_status_stub(provider: provider, id: bill_id, site_id: site_id)
      bill_payments_stub(provider: provider, id: bill_id, site_id: site_id)
    end

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

    context 'errors' do
      let!(:amount_value) { 3.0 }

      before do
        bill_create_with_validation_error_stub(provider: provider, id: bill_id, site_id: site_id)
      end
      it '#create responses with error' do
        response = api_client.resources.bills.create(id: bill_id, site_id: site_id, params: bill_params)

        expect(response['errorCode']).to eq('validation.error')
        expect(response['description']).to eq('Validation error')
        expect(response['cause']['amount']).to eq(['Invalid money format. Should have 2 fraction digits'])
        expect(response).to_not have_key('payUrl')
      end
    end
  end

  describe 'refunds resources' do
    let!(:refund_id) { '899343443' }
    let!(:refund_params) do
      {
        amount: {
          currency: 'RUB',
          value: '2.00'
        }
      }
    end

    before do
      refund_create_stub(provider: provider,
                         site_id: site_id,
                         payment_id: payment_id,
                         refund_id: refund_id)
      refund_status_stub(provider: provider,
                         site_id: site_id,
                         payment_id: payment_id,
                         refund_id: refund_id)
      refund_statuses_stub(provider: provider, site_id: site_id, payment_id: payment_id)
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

    context 'errors' do
      let!(:refund_params) do
        {
          amount: {
            # currency: 'RUB',
            value: '2.00'
          }
        }
      end

      before do
        refund_create_bad_request_error_stub(provider: provider,
                                             site_id: site_id,
                                             payment_id: payment_id,
                                             refund_id: refund_id)
      end

      it '#create responses with error' do
        response = api_client.resources.refunds.create(site_id: site_id,
                                                       payment_id: payment_id,
                                                       refund_id: refund_id,
                                                       params: refund_params)

        expect(response['errorCode']).to eq('http.message.conversion.failed')
        expect(response['description']).to eq('Bad request')
      end
    end
  end

  describe 'captures resources' do
    let!(:capture_id) { 'capture-id' }

    before do
      capture_create_stub(provider: provider,
                          site_id: site_id,
                          payment_id: payment_id,
                          capture_id: capture_id)
      capture_status_stub(provider: provider,
                          site_id: site_id,
                          payment_id: payment_id,
                          capture_id: capture_id)
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

    context 'errors' do
      before do
        capture_create_repeated_error_stub(provider: provider,
                                           site_id: site_id,
                                           payment_id: payment_id,
                                           capture_id: capture_id)
      end

      it '#create responses with error' do
        response = api_client.resources.captures.create(site_id: site_id, payment_id: payment_id,
                                                        capture_id: capture_id)

        expect(response['errorCode']).to eq('payin.incorrect-method-invocation')
        expect(response['userMessage']).to eq('Cannot perform this operation')
        expect(response['description']).to eq('Capture already done for this payment')
      end
    end
  end
end
