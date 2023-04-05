# frozen_string_literal: true

RSpec.describe Qiwi::Kassa::Notification do
  let!(:data) do
    { payment: { paymentId: "4226144",
                 type: "PAYMENT",
                 createdDateTime: "2019-10-02T18:10:12+03:00",
                 status: { value: "SUCCESS", changedDateTime: "2019-10-02T18:10:13+03:00" },
                 amount: { value: 2.0, currency: "RUB" },
                 paymentMethod: { type: "CARD", maskedPan: "427630******6080", rrn: nil, authCode: nil },
                 customer: { ip: "46.158.132.222", email: "test@test.com", phone: "0" },
                 gatewayData: { type: "ACQUIRING", authCode: "181218" },
                 billId: "9829394:982939419",
                 flags: [] },
      type: "PAYMENT",
      version: "1" }
  end

  let!(:signature) do
    '0572c2153b1b57b1eddb9124ca6b8868e57eb3dce29220417922f18e7788285c'
  end

  let!(:skey) { 'skey' }

  subject { described_class.new(data: data) }

  it '#to_h' do
    expect(subject.to_h.keys)
      .to eq(%w[payment_id type created_date_time status amount payment_method customer gateway_data bill_id flags])
    expect(subject.to_h['amount']).to eq({ 'currency' => 'RUB', 'value' => 2.0 })
    expect(subject.to_h['status']).to eq({ 'changed_date_time' => '2019-10-02T18:10:13+03:00', 'value' => 'SUCCESS' })
  end

  it '#valid?' do
    expect(subject.valid?(secret_key: skey, signature: signature)).to be true
  end

  it '#success?' do
    expect(subject.success?).to be true
  end

  context 'error response' do
    let!(:data) do
      { payment: { paymentId: "4226144",
                   type: "PAYMENT",
                   createdDateTime: "2019-10-02T18:10:12+03:00",
                   status: { value: "DECLINED",
                             changedDateTime: "2019-10-02T18:10:13+03:00",
                             reasonCode: "reason code",
                             reasonMessage: "reason message",
                             errorCode: "error code" },
                   amount: { value: 2.0, currency: "RUB" },
                   flags: [] },
        type: "PAYMENT",
        version: "1" }
    end

    it '#success?' do
      expect(subject.success?).to be false
    end

    it '#error' do
      expect(subject.error).to eq({ error_code: 'error code',
                                    reason_code: 'reason code',
                                    reason_message: 'reason message' })
    end
  end

  context 'unsupported notification type' do
    let!(:data) do
      { checkCard: { type: "CHECK_CARD", flags: [] },
        type: "CHECK_CARD",
        version: "1" }
    end

    it 'raises UnsupportedTypeError' do
      expect { subject }
        .to raise_error(described_class::UnsupportedTypeError, 'Unsupported notification type: CHECK_CARD.')
    end
  end
end
