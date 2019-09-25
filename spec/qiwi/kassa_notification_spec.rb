# frozen_string_literal: true

RSpec.describe Qiwi::Kassa::Notification do
  let!(:body) {
    {
      'siteId' => '23044',
      'billId' => '893794793973',
      'amount' => {
        'value' => 100,
        'currency' => 'RUB'
      },
      'status' => {
        'value' => 'WAITING'
      }
    }
  }

  let!(:signature) { '5d509cd679171c4b87e172c7ddc6b82d03a2b5440b014b671b4d36b7a4193f53' }
  let!(:skey) { 'skey' }

  it '#valid?' do
    expect(described_class.new(signature: signature, body: body, secret_key: skey).valid?).to be true
  end
end
