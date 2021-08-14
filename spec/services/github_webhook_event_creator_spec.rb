require 'rails_helper'

RSpec.describe GithubWebhookEventCreator do
  let(:service) { described_class.new(params) }
  let(:params) do
    {
      metadata: {},
      type: 'pull_request',
      action: 'open',
      github_hook_id: github_hook.id
    }
  end
  let(:github_hook) { create(:github_hook) }

  describe '.call' do
    context 'with valid params' do
      it 'should create a github webhook event' do
        result = nil
        expect {
          result = service.call
        }.to change(GithubWebhookEvent, :count).by(1)
        expect(result.status).to eq(BaseService::SUCCESS)
        expect(result.data).to be_a(GithubWebhookEvent)
      end
    end
  end
end
