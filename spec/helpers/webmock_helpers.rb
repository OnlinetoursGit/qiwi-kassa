# frozen_string_literal: true

module QiwiKassaWebMock
  def bill_create_stub(url:, id:)
    stub_request(:put, url + "bills/#{id}")
      .to_return(
        body: File.read('./spec/fixtures/resources/bills/create.json'),
        headers: { 'Content-Type' => 'application/json' },
        status: 200
      )
  end

  def bill_status_stub(url:, id:)
    stub_request(:get, url + "bills/#{id}")
      .to_return(
        body: File.read('./spec/fixtures/resources/bills/status.json'),
        headers: { 'Content-Type' => 'application/json' },
        status: 200
      )
  end

  def bill_reject_stub(url:, id:)
    stub_request(:post, url + "bills/#{id}/reject")
      .to_return(
        body: File.read('./spec/fixtures/resources/bills/reject.json'),
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
