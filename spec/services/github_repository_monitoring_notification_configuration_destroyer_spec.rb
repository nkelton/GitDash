require 'rails_helper'

RSpec.describe GithubRepositoryMonitoringNotificationConfigurationDestroyer do
  let(:service) { described_class.new(config) }
  let(:github_repository) { create(:github_repository) }
  let(:config) { create(:github_repository_monitoring_configuration, github_repository: github_repository) }
  let!(:github_hook) { create(:github_hook, github_repository: github_repository) }

  describe '.call' do
    context 'with valid params' do
      before do
        expect(service).to receive(:remove_hook_from_github!).and_return(nil)
      end

      it 'should delete github hook and github repository config' do
        result = nil
        expect {
          result = service.call
        }.to change(GithubRepositoryMonitoringConfiguration, :count).by(-1)
        .and change(GithubHook, :count).by(-1)
        expect(result.status).to eq(BaseService::SUCCESS)
        expect(result.data).to be_nil
      end
    end
  end
end
