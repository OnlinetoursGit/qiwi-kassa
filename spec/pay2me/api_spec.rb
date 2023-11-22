# frozen_string_literal: true

RSpec.describe Qiwi::Kassa::Api do
  let!(:site_id) { 'site-id' }
  let!(:payment_id) { 'bb918d93-a3f6-4c89-b753-c9e2311f1318' }
  let!(:amount_value) { 10 }
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
  let(:api_client) { described_class.new(secret_key: 'skey', provider: provider) }

  before do
    stub_const('Qiwi::Kassa::API_HOSTS', { pay2me: 'https://test.pay2me.com' })
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
      let!(:amount_value) { 'test' }

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

  describe 'captures resources' do
    let!(:capture_id) { '123456' }

    before do
      capture_create_stub(provider: provider, site_id: site_id, payment_id: payment_id, capture_id: capture_id)
    end

    it '#create', :aggregate_failures do
      response = api_client.resources.captures.create(site_id: site_id, payment_id: payment_id, capture_id: capture_id)

      expect(response['captureId']).to eq(capture_id)
      expect(response['amount']['value']).to eq(bill_params[:amount][:value])
      expect(response['capturedAmount']['value']).to eq(bill_params[:amount][:value])
      expect(response['refundedAmount']['value']).to be_zero
      expect(response['status']['value']).to eq('COMPLETED')
    end

    context 'errors' do
      let!(:amount_value) { 'test' }
      let!(:capture_params) do
        {
          amount: {
            currency: 'RUB',
            value: amount_value
          }
        }
      end

      before do
        capture_create_validation_error_stub(provider: provider,
                                             site_id: site_id,
                                             payment_id: payment_id,
                                             capture_id: capture_id,
                                             params: capture_params)
      end

      it '#create responses with error' do
        response = api_client.resources.captures.create(site_id: site_id, payment_id: payment_id,
                                                        capture_id: capture_id, params: capture_params)

        expect(response['errorCode']).to eq(101003)
        expect(response['userMessage']).to eq('Internal error')
        expect(response['description']).to eq('INPUT DATA ERROR | service_stream_psp.route_stream | `amount` request param value is incorrect')
      end
    end
  end

  describe 'refunds resources' do
    let!(:refund_id) { '123456' }
    let!(:refund_params) do
      {
        amount: {
          currency: 'RUB',
          value: 10
        }
      }
    end

    before do
      refund_create_stub(provider: provider,
                         site_id: site_id,
                         payment_id: payment_id,
                         refund_id: refund_id)
    end

    it '#create', :aggregate_failures do
      response = api_client.resources.refunds.create(site_id: site_id,
                                                     payment_id: payment_id,
                                                     refund_id: refund_id,
                                                     params: refund_params)

      expect(response['refundId']).to eq(refund_id)
      expect(response['amount']['value']).to eq(refund_params[:amount][:value])
      expect(response['capturedAmount']['value']).to be_zero
      expect(response['refundedAmount']['value']).to eq(refund_params[:amount][:value])
      expect(response['status']['value']).to eq('COMPLETED')
      expect(response['flags']).to include('REVERSAL')
    end

    context 'errors' do
      let!(:refund_params) do
        {
          amount: {
            currency: 'RUB',
            value: 20
          }
        }
      end

      before do
        refund_create_validation_error_stub(provider: provider,
                                            site_id: site_id,
                                            payment_id: payment_id,
                                            refund_id: refund_id,
                                            params: refund_params)
      end

      it '#create responses with error', :aggregate_failures do
        response = api_client.resources.refunds.create(site_id: site_id,
                                                       payment_id: payment_id,
                                                       refund_id: refund_id,
                                                       params: refund_params)

        expect(response['errorCode']).to eq(101003)
        expect(response['userMessage']).to eq('Internal error')
        expect(response['description']).to eq('INPUT DATA ERROR | service_stream_psp.route_stream | `amount` request param value is incorrect')
      end
    end
  end
end
