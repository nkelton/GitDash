require 'rails_helper'

RSpec.describe GithubHookEventProcessor do
  let(:service) { described_class.new(inspector_spy) }
  let(:inspector_spy) do
    spy.tap do |s|
      allow(s).to receive(:hook?).and_return(hook)
      allow(s).to receive(:pull_request?).and_return(pull_request)
    end
  end

  before do
    allow(Inspectors::GithubWebhook).to receive(:new).and_return(inspector_spy)
  end

  describe '.call' do
    context 'when processing a pull request' do
      let(:hook) { false }
      let(:pull_request) { true }
      let(:process_result) do
        spy.tap do |s|
          allow(s).to receive(:status).and_return(BaseService::SUCCESS)
        end
      end

      before do
        expect(service).to receive(:process_pull_request).and_return(process_result)
      end

      it 'successfully processes the github webhook' do
        result = service.call
        expect(result.status).to eq(BaseService::SUCCESS)
      end
    end
  end
end
