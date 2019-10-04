# frozen_string_literal: true

RSpec.describe Qiwi::Kassa::Notification do
  let!(:data) do
    { 'payment' =>
      { 'paymentId' => '4226144',
        'type' => 'PAYMENT',
        'createdDateTime' => '2019-10-02T18:10:12+03:00',
        'status' => {
          'value' => 'SUCCESS', 'changedDateTime' => '2019-10-02T18:10:13+03:00'
        },
        'amount' => { 'value' => 2.0, 'currency' => 'RUB' },
        'paymentMethod' => {
          'type' => 'CARD',
          'maskedPan' => '427630******6080',
          'rrn' => nil,
          'authCode' => nil
        },
        'customer' => {
          'ip' => '46.158.132.222',
          'email' => 'test@test.com',
          'phone' => '0'
        },
        'gatewayData' => { 'type' => 'ACQUIRING', 'authCode' => '181218' },
        'billId' => '9829394:982939419',
        'flags' => [] },
      'type' => 'PAYMENT',
      'version' => '1' }
  end

  let!(:signature) do
    'c890a9de4bde27292cfe83131aea10432ea68bd9205ef75a37edc419f9746159'
  end

  let!(:skey) { 'skey' }

  it '#valid?' do
    expect(described_class.new(signature: signature, data: data, secret_key: skey)
      .valid?).to be true
  end
end
