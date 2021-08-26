require 'rails_helper'

RSpec.describe GithubRepositoryMonitoringConfigurationUpdater do
  let(:service) { described_class.new(config, notification_types) }
  let(:config) { create(:github_repository_monitoring_configuration, notification_types: notification_types) }
  let(:config_types) { [] }
  let(:notification_types) { %w[discussion discussion_comment] }
  let!(:github_hook) { create(:github_hook, github_repository: config.github_repository) }

  describe '.execute' do
    context 'with valid parameters' do
      let(:update_spy) do
        spy.tap do |s|
          allow(s).to receive(:to_hash).and_return(metadata)
        end
      end
      let(:metadata) do
        {
          'test' => 'test'
        }
      end

      before do
        allow(service).to receive(:update_github_hook!).and_return(update_spy)
      end

      context 'when adding events' do
        it 'updates the monitoring configuration and associated hook' do
          result = service.call

          expect(config.reload.notification_types).to eq(notification_types)
          expect(github_hook.reload.metadata).to eq(metadata)
          expect(result.status).to eq(BaseService::SUCCESS)
          expect(result.data).to be_a(GithubRepositoryMonitoringConfiguration)
        end
      end

      context 'when removing events' do
        let(:config_types) { %w[discussion discussion_comment] }
        let(:notification_types) { ['discussion'] }

        it 'updates the monitoring configuration and associated hook' do
          result = service.call

          expect(config.reload.notification_types).to eq(notification_types)
          expect(github_hook.reload.metadata).to eq(metadata)
          expect(result.status).to eq(BaseService::SUCCESS)
          expect(result.data).to be_a(GithubRepositoryMonitoringConfiguration)
        end
      end

      context 'when adding and removing events' do
        let(:config_types) { %w[discussion discussion_comment] }
        let(:notification_types) { %w[discussion pull_request] }

        it 'updates the monitoring configuration and associated hook' do
          result = service.call

          expect(config.reload.notification_types).to eq(notification_types)
          expect(github_hook.reload.metadata).to eq(metadata)
          expect(result.status).to eq(BaseService::SUCCESS)
          expect(result.data).to be_a(GithubRepositoryMonitoringConfiguration)
        end
      end
    end
  end
end
