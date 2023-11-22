# frozen_string_literal: true

module QiwiKassaWebMock
  FIXTURE_BASIC_PATHS = {
    qiwi: "spec/fixtures/qiwi/resources",
    pay2me: "spec/fixtures/pay2me/resources"
  }.freeze

  def bill_create_stub(provider:, id:, site_id:)
    stub_request(:put, "#{base_url(provider)}/#{site_id}/bills/#{id}")
      .to_return(
        body: File.read("./#{fixtures_basic_path(provider)}/bills/create.json"),
        headers: { 'Content-Type' => 'application/json' },
        status: 200
      )
  end

  def bill_create_with_validation_error_stub(provider:, id:, site_id:)
    stub_request(:put, "#{base_url(provider)}/#{site_id}/bills/#{id}")
      .to_return(
        body: File.read("./#{fixtures_basic_path(provider)}/bills/create_validation_error.json"),
        headers: { 'Content-Type' => 'application/json' },
        status: 200
      )
  end

  def bill_status_stub(provider:, id:, site_id:)
    stub_request(:get, "#{base_url(provider)}/#{site_id}/bills/#{id}/details")
      .to_return(
        body: File.read("./#{fixtures_basic_path(provider)}/bills/status.json"),
        headers: { 'Content-Type' => 'application/json' },
        status: 200
      )
  end

  def bill_payments_stub(provider:, id:, site_id:)
    stub_request(:get, "#{base_url(provider)}/#{site_id}/bills/#{id}")
      .to_return(
        body: File.read("./#{fixtures_basic_path(provider)}/bills/payments.json"),
        headers: { 'Content-Type' => 'application/json' },
        status: 200
      )
  end

  def refund_create_stub(provider:, site_id:, payment_id:, refund_id:)
    stub_request(:put,
                 "#{base_url(provider)}/#{site_id}/payments/#{payment_id}/refunds/#{refund_id}")
      .to_return(
        body: File.read("./#{fixtures_basic_path(provider)}/refunds/create.json"),
        headers: { 'Content-Type' => 'application/json' },
        status: 200
      )
  end

  def refund_create_bad_request_error_stub(provider:, site_id:, payment_id:, refund_id:)
    stub_request(:put,
                 "#{base_url(provider)}/#{site_id}/payments/#{payment_id}/refunds/#{refund_id}")
      .to_return(
        body: File.read("./#{fixtures_basic_path(provider)}/refunds/bad_request_error.json"),
        headers: { 'Content-Type' => 'application/json' },
        status: 200
      )
  end

  def refund_create_validation_error_stub(provider:, site_id:, payment_id:, refund_id:, params:)
    stub_request(:put,
                 "#{base_url(provider)}/#{site_id}/payments/#{payment_id}/refunds/#{refund_id}")
      .with(body: params)
      .to_return(
        body: File.read("./#{fixtures_basic_path(provider)}/refunds/create_validation_error.json"),
        headers: { 'Content-Type' => 'application/json' },
        status: 200
      )
  end

  def refund_status_stub(provider:, site_id:, payment_id:, refund_id:)
    stub_request(:get,
                 "#{base_url(provider)}/#{site_id}/payments/#{payment_id}/refunds/#{refund_id}")
      .to_return(
        body: File.read("./#{fixtures_basic_path(provider)}/refunds/status.json"),
        headers: { 'Content-Type' => 'application/json' },
        status: 200
      )
  end

  def refund_statuses_stub(provider:, site_id:, payment_id:)
    stub_request(:get, "#{base_url(provider)}/#{site_id}/payments/#{payment_id}/refunds")
      .to_return(
        body: File.read("./#{fixtures_basic_path(provider)}/refunds/statuses.json"),
        headers: { 'Content-Type' => 'application/json' },
        status: 200
      )
  end

  def capture_create_stub(provider:, site_id:, payment_id:, capture_id:)
    stub_request(:put,
                 "#{base_url(provider)}/#{site_id}/payments/#{payment_id}/captures/#{capture_id}")
      .to_return(
        body: File.read("./#{fixtures_basic_path(provider)}/captures/create.json"),
        headers: { 'Content-Type' => 'application/json' },
        status: 200
      )
  end

  def capture_create_validation_error_stub(provider:, site_id:, payment_id:, capture_id:, params:)
    stub_request(:put,
                 "#{base_url(provider)}/#{site_id}/payments/#{payment_id}/captures/#{capture_id}")
      .with(body: params)
      .to_return(
        body: File.read("./#{fixtures_basic_path(provider)}/captures/create_validation_error.json"),
        headers: { 'Content-Type' => 'application/json' },
        status: 200
      )
  end

  def capture_create_repeated_error_stub(provider:, site_id:, payment_id:, capture_id:)
    stub_request(:put,
                 "#{base_url(provider)}/#{site_id}/payments/#{payment_id}/captures/#{capture_id}")
      .to_return(
        body: File.read("./#{fixtures_basic_path(provider)}/captures/repeated_capture_attemption_error.json"),
        headers: { 'Content-Type' => 'application/json' },
        status: 200
      )
  end

  def capture_status_stub(provider:, site_id:, payment_id:, capture_id:)
    stub_request(:get,
                 "#{base_url(provider)}/#{site_id}/payments/#{payment_id}/captures/#{capture_id}")
      .to_return(
        body: File.read("./#{fixtures_basic_path(provider)}/captures/status.json"),
        headers: { 'Content-Type' => 'application/json' },
        status: 200
      )
  end

  private

  def base_url(provider)
    "#{host(provider)}#{basic_path(provider)}"
  end

  def host(provider)
    Qiwi::Kassa::API_HOSTS[provider]
  end

  def basic_path(provider)
    Qiwi::Kassa::Resource::BASIC_PATHS[provider]
  end

  def fixtures_basic_path(provider)
    FIXTURE_BASIC_PATHS[provider]
  end
end
