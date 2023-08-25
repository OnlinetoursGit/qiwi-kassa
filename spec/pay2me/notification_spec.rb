# frozen_string_literal: true

RSpec.describe Qiwi::Kassa::Notification do
  let!(:data) do
    { payment: { paymentId: '3395948500',
                 type: 'PAYMENT',
                 createdDateTime: '2023-07-05T10:49:36.681+03:00',
                 status: { value: 'SUCCESS',
                           changedDateTime: '2023-07-05T10:50:12.117+03:00' },
                 amount: { value: 10, currency: 'RUB' },
                 paymentMethod: { type: 'CARD',
                                  maskedPan: '426803xxxxxx5792',
                                  rrn: '318691263020',
                                  authCode: '227004' },
                 paymentCardInfo: { issuingCountry: 'rus',
                                    issuingBank: 'promsvyazbank',
                                    paymentSystem: 'visa',
                                    fundingSource: 'credit',
                                    paymentSystemProduct: 'visa classic' },
                 customer: { ip: '31.41.153.84' },
                 customFields: { cf1: '2217525' } },
      type: 'PAYMENT',
      version: '1' }
  end

  let!(:signature) do
    '8da2dfdc97fb137aefcb5d94ad0445cac76fcb73f440e63b222e2d5f6ee2dd5b'
  end

  let!(:skey) { 'skey' }

  subject { described_class.new(data: data) }

  it '#to_h', :aggregate_failures do
    expect(subject.to_h.keys)
      .to match_array(%w[payment_id type created_date_time status amount payment_method payment_card_info customer
                         custom_fields])
    expect(subject.to_h['amount']).to eq({ 'currency' => 'RUB', 'value' => 10 })
    expect(subject.to_h['status']).to eq({ 'changed_date_time' => '2023-07-05T10:50:12.117+03:00',
                                           'value' => 'SUCCESS' })
  end

  it '#valid?' do
    expect(subject.valid?(secret_key: skey, signature: signature)).to be true
  end

  it '#success?' do
    expect(subject.success?).to be true
  end

  context 'error response' do
    let!(:data) do
      { payment: { paymentId: '3395948500',
                   type: 'PAYMENT',
                   createdDateTime: '2023-07-05T10:49:36.681+03:00',
                   status: { value: 'DECLINED',
                             changedDateTime: '2023-07-05T10:50:12.117+03:00' },
                   amount: { value: 10, currency: 'RUB' } },
        type: 'PAYMENT',
        version: '1' }
    end

    it '#success?' do
      expect(subject.success?).to be false
    end

    # TODO: Включить после добавления необходимых полей на стороне Pay2me
    xit '#error' do
      expect(subject.error).to eq({ error_code: 'error code',
                                    reason_code: 'reason code',
                                    reason_message: 'reason message' })
    end
  end

  context 'unsupported notification type' do
    let!(:data) do
      { checkCard: { type: 'CHECK_CARD', flags: [] },
        type: 'CHECK_CARD',
        version: '1' }
    end

    it 'raises UnsupportedTypeError' do
      expect { subject }
        .to raise_error(described_class::UnsupportedTypeError, 'Unsupported notification type: CHECK_CARD.')
    end
  end
end
