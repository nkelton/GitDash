require 'rails_helper'

RSpec.describe GithubHookCreator do
  let(:service) { described_class.new(config) }

  describe '.call' do
    context 'when params are valid' do
      let(:config) { create(:github_repository_monitoring_configuration) }
      let(:hook_spy) do
        spy.tap do |s|
          allow(s).to receive(:id).and_return(1)
          allow(s).to receive(:to_hash).and_return({})
        end
      end

      before do
        expect(service).to receive(:create_github_hook!).and_return(hook_spy)
      end

      it 'should create a github hook' do
        result = nil
        expect {
          result = service.call
        }.to change { GithubHook.count }.by(1)
        .and change { config.reload.github_hook }.from(nil)
        expect(result.status).to eq(BaseService::SUCCESS)
        expect(result.data).to be_a(GithubHook)
      end
    end
  end

end
