# frozen_string_literal: true

module QiwiKassaWebMock
  def bill_create_stub(url:, id:, site_id:)
    stub_request(:put, url + "partner/payin/v1/sites/#{site_id}/bills/#{id}")
      .to_return(
        body: File.read('./spec/fixtures/resources/bills/create.json'),
        headers: { 'Content-Type' => 'application/json' },
        status: 200
      )
  end

  def bill_status_stub(url:, id:, site_id:)
    stub_request(:get, url + "partner/payin/v1/sites/#{site_id}/bills/#{id}/details")
      .to_return(
        body: File.read('./spec/fixtures/resources/bills/status.json'),
        headers: { 'Content-Type' => 'application/json' },
        status: 200
      )
  end

  def bill_payments_stub(url:, id:, site_id:)
    stub_request(:get, url + "partner/payin/v1/sites/#{site_id}/bills/#{id}")
      .to_return(
        body: File.read('./spec/fixtures/resources/bills/payments.json'),
        headers: { 'Content-Type' => 'application/json' },
        status: 200
      )
  end

  def refund_create_stub(url:, bill_id:, refund_id:)
    stub_request(:put, url + "bills/#{bill_id}/refunds/#{refund_id}")
      .to_return(
        body: File.read('./spec/fixtures/resources/refunds/create.json'),
        headers: { 'Content-Type' => 'application/json' },
        status: 200
      )
  end

  def refund_status_stub(url:, bill_id:, refund_id:)
    stub_request(:get, url + "bills/#{bill_id}/refunds/#{refund_id}")
      .to_return(
        body: File.read('./spec/fixtures/resources/refunds/status.json'),
        headers: { 'Content-Type' => 'application/json' },
        status: 200
      )
  end
end
