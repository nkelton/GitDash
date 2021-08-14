require 'rails_helper'

RSpec.describe GithubPullRequestProcessor do
  let(:service) { described_class.new(webhook_spy) }
  let(:webhook_spy) do
    spy.tap do |s|
      allow(s).to receive(:action).and_return(action)
      allow(s).to receive(:pull_request_inspector).and_return(pull_request_spy)
    end
  end
  let(:action) { 'test' }
  let(:pull_request_spy) do
    spy.tap do |s|
      allow(s).to receive(:title).and_return(title)
      allow(s).to receive(:github_id).and_return(github_id)
      allow(s).to receive(:body).and_return(body)
      allow(s).to receive(:state).and_return(state)
    end
  end
  let(:title) { 'test' }
  let(:github_id) { 123 }
  let(:body) { 'blah blah' }
  let(:state) { 'open' }
  let(:upsertor_spy) do
    spy.tap do |s|
      allow(s).to receive(:failure?).and_return(upsertor_failure)
    end
  end
  let(:upsertor_result) do
    spy.tap do |s|
      allow(s).to receive(:failure?).and_return(upsertor_failure)
    end
  end
  let(:creator_spy) do
    spy.tap do |s|
      allow(s).to receive(:call).and_return(creator_result)
    end
  end
  let(:creator_result) do
    spy.tap do |s|
      allow(s).to receive(:failure?).and_return(creator_failire)
    end
  end

  describe '.call' do
    context 'when services return success' do
      let(:failure) { false }
      let(:upsertor_failure) { false }
      let(:creator_failire) { false }
      let(:github_hook_id) { 123 }

      before do
        expect(GithubPullRequestUpsertor).to receive(:new).and_return(upsertor_spy)
        expect(GithubWebhookEventCreator).to receive(:new).and_return(creator_spy)
        expect(service).to receive(:github_hook_id).and_return(github_hook_id)
      end

      it 'successfully processes github pull requests' do
        result = service.call
        expect(result.status).to eq(BaseService::SUCCESS)
        expect(result.data).to be_nil
      end
    end
  end
end
