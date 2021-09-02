require 'rails_helper'

RSpec.describe GithubRepositoryCreator do
  let(:service) { described_class.new(github_account) }
  let(:github_account) { create(:github_account) }

  describe '.call' do
    context 'when params are valid' do
      let(:repo) do
        spy.tap do |s|
          allow(s).to receive(:id).and_return(1)
          allow(s).to receive(:name).and_return('Test')
          allow(s).to receive(:to_hash).and_return({})
        end
      end
      let(:repositories) { [repo] }

      before do
        expect(service).to receive(:retrieve_repositories!).and_return(repositories)
      end

      it 'should create repositories' do
        result = nil
        expect {
          result = service.call
        }.to change { GithubRepository.count }.by(1)
        .and change { github_account.reload.github_repositories.count }.from(0).to(1)
        .and have_enqueued_job(GithubRepositoryContributorCreatorJob)
        expect(result.status).to eq(BaseService::SUCCESS)
        expect(result.data.length).to eq(1)
      end
    end
  end

end