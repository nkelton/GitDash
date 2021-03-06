require 'rails_helper'

RSpec.describe GithubPullRequestEventProcessor do
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
    context 'when service returns success' do
      let(:failure) { false }
      let(:upsertor_failure) { false }
      let(:creator_failire) { false }
      let(:github_hook_id) { 123 }
      let(:user) { create(:user) }

      before do
        expect(GithubPullRequestUpsertor).to receive(:new).and_return(upsertor_spy)
      end

      context 'when filtering for sender' do
        before do
          expect(GithubHookEventCreator).to receive(:new).and_return(creator_spy)
          expect(service).to receive(:github_hook_id).and_return(github_hook_id)
          expect(service).to receive(:user).and_return(user)
          expect(service).to receive(:filtering_for_sender?).and_return(true)
        end

        it 'successfully processes github pull requests and enqueues job' do
          result = nil
          expect {
            result = service.call
          }.to have_enqueued_job(NotificationSenderJob)
          expect(result.status).to eq(BaseService::SUCCESS)
          expect(result.data).to be_nil
        end
      end

      context 'when not filtering for sender' do
        before do
          expect(service).to receive(:filtering_for_sender?).and_return(false)
        end

        it 'successfully processes github pull requests and does not enqueues job' do
          result = service.call
          expect(result.status).to eq(BaseService::SUCCESS)
          expect(result.data).to be_nil
        end
      end
    end
  end
end
