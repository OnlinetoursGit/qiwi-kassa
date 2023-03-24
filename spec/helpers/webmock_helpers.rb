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


  def bill_create_with_validation_error_stub(url:, id:, site_id:)
    stub_request(:put, url + "partner/payin/v1/sites/#{site_id}/bills/#{id}")
      .to_return(
        body: File.read('./spec/fixtures/resources/bills/create_validation_error.json'),
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

  def refund_create_stub(url:, site_id:, payment_id:, refund_id:)
    stub_request(:put, url + "partner/payin/v1/sites/#{site_id}/payments/#{payment_id}/refunds/#{refund_id}")
      .to_return(
        body: File.read('./spec/fixtures/resources/refunds/create.json'),
        headers: { 'Content-Type' => 'application/json' },
        status: 200
      )
  end

  def refund_create_bad_request_error_stub(url:, site_id:, payment_id:, refund_id:)
    stub_request(:put, url + "partner/payin/v1/sites/#{site_id}/payments/#{payment_id}/refunds/#{refund_id}")
      .to_return(
        body: File.read('./spec/fixtures/resources/refunds/bad_request_error.json'),
        headers: { 'Content-Type' => 'application/json' },
        status: 200
      )
  end

  def refund_status_stub(url:, site_id:, payment_id:, refund_id:)
    stub_request(:get, url + "partner/payin/v1/sites/#{site_id}/payments/#{payment_id}/refunds/#{refund_id}")
      .to_return(
        body: File.read('./spec/fixtures/resources/refunds/status.json'),
        headers: { 'Content-Type' => 'application/json' },
        status: 200
      )
  end

  def refund_statuses_stub(url:, site_id:, payment_id:)
    stub_request(:get, url + "partner/payin/v1/sites/#{site_id}/payments/#{payment_id}/refunds")
      .to_return(
        body: File.read('./spec/fixtures/resources/refunds/statuses.json'),
        headers: { 'Content-Type' => 'application/json' },
        status: 200
      )
  end

  def capture_create_stub(url:, site_id:, payment_id:, capture_id:)
    stub_request(:put, url + "partner/payin/v1/sites/#{site_id}/payments/#{payment_id}/captures/#{capture_id}")
      .to_return(
        body: File.read('./spec/fixtures/resources/captures/create.json'),
        headers: { 'Content-Type' => 'application/json' },
        status: 200
      )
  end

  def capture_create_repeated_error_stub(url:, site_id:, payment_id:, capture_id:)
    stub_request(:put, url + "partner/payin/v1/sites/#{site_id}/payments/#{payment_id}/captures/#{capture_id}")
      .to_return(
        body: File.read('./spec/fixtures/resources/captures/repeated_capture_attemption_error.json'),
        headers: { 'Content-Type' => 'application/json' },
        status: 200
      )
  end

  def capture_status_stub(url:, site_id:, payment_id:, capture_id:)
    stub_request(:get, url + "partner/payin/v1/sites/#{site_id}/payments/#{payment_id}/captures/#{capture_id}")
      .to_return(
        body: File.read('./spec/fixtures/resources/captures/status.json'),
        headers: { 'Content-Type' => 'application/json' },
        status: 200
      )
  end
end
