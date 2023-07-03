# frozen_string_literal: true

RSpec.describe Qiwi::Kassa::Api do
  let!(:site_id) { 'site-id' }
  let!(:payment_id) { 'bb918d93-a3f6-4c89-b753-c9e2311f1318' }

  let(:provider) { :pay2me }
  let!(:api_client) { described_class.new(secret_key: 'skey', provider: provider) }

  before(:each) do
    stub_const('Qiwi::Kassa::API_HOSTS', { pay2me: 'https://test.pay2me.com' })
    stub_const('Qiwi::Kassa::Resource::BASIC_PATHS', { pay2me: 'payin/v1/sites' })
  end
end
