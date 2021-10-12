require 'rails_helper'

RSpec.describe GithubRepositoryMonitoringNotificationConfigurationDestroyer do
  let(:service) { described_class.new(param) }
  let(:param) { config }
  let(:github_repository) { create(:github_repository) }
  let(:config) { create(:github_repository_monitoring_configuration, github_repository: github_repository) }
  let!(:github_hook) { create(:github_hook, github_repository: github_repository) }
  let!(:github_hook_event) { create(:github_hook_event, github_hook: github_hook) }
  let!(:monitoring_contributor) { create(:github_repository_monitoring_contributor, github_repository_monitoring_configuration: config) }

  describe '.call' do
    context 'with valid params' do
      before do
        expect(service).to receive(:remove_hook_from_github!).and_return(nil)
      end

      it 'should delete github repository config, hook, hook events and monitoring contributors' do
        result = nil
        expect {
          result = service.call
        }.to change(GithubRepositoryMonitoringConfiguration, :count).by(-1)
        .and change(GithubHook, :count).by(-1)
        .and change(GithubHookEvent, :count).by(-1)
        .and change(GithubRepositoryMonitoringContributor, :count).by(-1)
        expect(result.status).to eq(BaseService::SUCCESS)
        expect(result.data).to be_nil
      end
    end

    context 'with invalid params' do
      let(:param) { nil }

      it 'should return failure' do
        result = nil
        expect {
          result = service.call
        }.to change(GithubRepositoryMonitoringConfiguration, :count).by(0)
        .and change(GithubHook, :count).by(0)
        .and change(GithubHookEvent, :count).by(0)
        .and change(GithubRepositoryMonitoringContributor, :count).by(0)
        expect(result.status).to eq(BaseService::FAILURE)
        expect(result.data).to be_nil
      end
    end
  end
end
