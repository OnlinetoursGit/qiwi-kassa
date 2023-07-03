# frozen_string_literal: true

RSpec.describe Qiwi::Kassa::Notification do
  let!(:signature) do
    '0572c2153b1b57b1eddb9124ca6b8868e57eb3dce29220417922f18e7788285c'
  end

  let!(:skey) { 'skey' }

  subject { described_class.new(data: {}) }
end
