require 'rails_helper'

RSpec.describe GithubRepositoryUpdater do
  let(:service) { described_class.new(github_repository, github_repository_attrs) }
  let(:github_repository_attrs) do
    {
      aasm_state: aasm_state
    }
  end

  describe '.call' do
    context 'with valid params' do
      context 'when activating a github_repository' do
        let(:github_repository) { create(:github_repository, aasm_state: 'inactive') }
        let(:aasm_state) { 'active' }

        it 'should transition the repository from inactive to active' do
          result = nil

          expect{
            result = service.call
          }.to change { github_repository.reload.aasm_state }.from('inactive').to('active')
          expect(result.data.first).to be_truthy
          expect(result.data.second).to be_a(GithubRepository)
          expect(result.status).to eq(BaseService::SUCCESS)
        end
      end

      context 'when deactivating a github_repository' do
        let(:github_repository) { create(:github_repository, aasm_state: 'active') }
        let(:aasm_state) { 'inactive' }

        it 'should transtion the repository from actove to inactive' do
          result = nil
          expect{
            result = service.call
          }.to change { github_repository.reload.aasm_state }.from('active').to('inactive')
          .and have_enqueued_job(GithubRepositoryMonitoringNotificationConfigurationDestroyerJob)
          expect(result.data.first).to be_falsey
          expect(result.data.second).to be_a(GithubRepository)
          expect(result.status).to eq(BaseService::SUCCESS)
        end
      end

      context 'when updating a monitoring config' do
        let(:github_repository) { create(:github_repository) }
        let(:github_repository_attrs) do
          {
            monitoring_configuration_attributes: {
              id: monitoring_config.id,
              notification_types: notification_types
            }
          }
        end
        let(:monitoring_config) { create(:github_repository_monitoring_configuration, github_repository: github_repository) }
        let(:notification_types) { %w[commit_comment pull_request_review] }

        it 'should enque job to update monitoring config' do
          result = nil
          expect {
            result = service.call
          }.to have_enqueued_job(GithubRepositoryMonitoringConfigurationUpdaterJob)
          expect(result.data.first).to be_falsey
          expect(result.data.second).to be_a(GithubRepository)
          expect(result.status).to eq(BaseService::SUCCESS)
        end
      end

    end
  end
end
