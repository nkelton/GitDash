require 'rails_helper'

RSpec.describe GithubRepositoryMonitoringConfigurationCreator do
  let(:service) { described_class.new(params) }
  let(:params) do
    {
      notification_types: notification_types,
      github_repository_id: repo.id
    }
  end

  describe '.call' do
    context 'when params are valid' do
      let(:repo) { create(:github_repository) }
      let(:notification_types) { [GithubRepositoryMonitoringConfiguration::NOTIFICATION_TYPES.sample] }

      it 'should create a github repository monitoring configuration and enque job to create github hook' do
        result = nil
        expect {
          result = service.call
        }.to change { GithubRepositoryMonitoringConfiguration.count }.by(1)
        .and change { repo.reload.monitoring_configuration }.from(nil)
        .and have_enqueued_job(GithubHookCreatorJob)
        expect(result.status).to eq(BaseService::SUCCESS)
        expect(result.data).to be_a(GithubRepositoryMonitoringConfiguration)
      end

    end
  end

end
