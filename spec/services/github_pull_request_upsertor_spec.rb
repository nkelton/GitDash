require 'rails_helper'

RSpec.describe GithubPullRequestUpsertor do
  let(:service) { described_class.new(params) }
  let(:params) do
    {
      title: title,
      body: body,
      state: state,
      metadata: {},
      github_id: github_id,
      github_repository_id: github_repository.id
    }
  end
  let(:title) { 'Testing' }
  let(:body) { 'blah blah blah' }
  let(:state) { 'closed' }
  let(:github_id) { '123' }
  let(:github_repository) { create(:github_repository) }

  describe '.call' do
    context 'with valid params' do
      context 'when pull request does not exist' do
        it 'creates a new pull request' do
          result = nil
          expect {
            result = service.call
          }.to change(GithubPullRequest, :count).by(1)
          expect(result.status).to eq(BaseService::SUCCESS)
          expect(result.data).to be_a(GithubPullRequest)
        end
      end
      context 'when pull request already exists' do
        let(:pull_request) { create(:github_pull_request) }
        let(:title) { 'New Title' }
        let(:body) { 'new blah blah blah' }
        let(:state) { 'open' }
        let(:github_id) { pull_request.github_id }

        it 'updates an existing pull request' do
          result = nil
          expect {
            result = service.call
            pull_request.reload
          }.to change { pull_request.title }
            .and change { pull_request.body }
            .and change { pull_request.state }
          expect(result.status).to eq(BaseService::SUCCESS)
          expect(result.data).to be_a(GithubPullRequest)
        end
      end
    end
  end

end
