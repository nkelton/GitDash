require 'rails_helper'

RSpec.describe GithubRepositorySync do
  let(:service) { described_class.new(github_account) }
  let(:github_account) { create(:github_account) }

  let(:repo_spy) do
    spy.tap do |s|
      allow(s).to receive(:id).and_return(1)
      allow(s).to receive(:name).and_return('Repository')
      allow(s).to receive(:to_hash).and_return({})
    end
  end

  before do
    expect(service).to receive(:retrieve_repositories!).and_return([repo_spy])
    expect(service).to receive(:existing_repository_ids).and_return(existing_repository_ids)
  end

  context 'when retrieving new repository' do
    let(:existing_repository_ids) { [] }
    it 'should create new repositories' do
      result = nil
      expect {
        result = service.call
      }.to change { GithubRepository.count }.from(0).to(1)
    end
  end

  context 'when retrieving existing repository' do
    let(:existing_repository_ids) { [1] }
    it 'should not create new repositories' do
      result = nil
      expect {
        result = service.call
      }.to_not change { GithubRepository.count }
    end
  end
end
