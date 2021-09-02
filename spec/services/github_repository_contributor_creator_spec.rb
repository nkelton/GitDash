require 'rails_helper'

RSpec.describe GithubRepositoryContributorCreator do
  let(:service) { described_class.new(github_repository) }

  describe '.call' do
    context 'with valid params' do
      let(:github_repository) { create(:github_repository) }
      let(:contributor) do
        spy.tap do |s|
          allow(s).to receive(:id).and_return(1)
          allow(s).to receive(:login).and_return('Bob')
          allow(s).to receive(:html_url).and_return('www.test.com/contributor')
          allow(s).to receive(:contributions).and_return(3)
        end
      end
      let(:contributors) { [contributor] }


      before do
        expect(service).to receive(:retrieve_contributors!).and_return(contributors)
      end

      it 'should create contributors' do
        result = nil
        expect {
          result = service.call
        }.to change { GithubRepositoryContributor.count }.by(1)
        .and change { github_repository.reload.contributors.count }.from(0).to(1)
        expect(result.status).to eq(BaseService::SUCCESS)
        expect(result.data.length).to eq(1)
      end

    end
  end


end
