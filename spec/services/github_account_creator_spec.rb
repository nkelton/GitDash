require 'rails_helper'

RSpec.describe GithubAccountCreator do
  let(:service) { described_class.new(params) }
  let(:user) { create(:user) }
  let(:params) do
    {
      token: token,
      user_id: user.id
    }
  end
  let(:token) { '123' }

  describe '.call' do
    context 'when params are valid' do
      before do
        allow(service).to receive(:valid_token?).and_return(true)
        expect(service).to receive(:github_metadata).and_return({})
      end

      it 'should create a github account and associate it with the correct user' do
        result = nil
        expect {
          result = service.call
        }.to change { GithubAccount.count }.by(1)
        .and change { user.reload.github_account }.from(nil)
        .and have_enqueued_job(GithubRepositoryCreatorJob)
        expect(result.status).to eq(BaseService::SUCCESS)
        expect(result.data).to be_a(GithubAccount)
      end
    end

    context 'when params are invalid' do
      let(:token) { nil }
      it 'should return failure' do
        result = nil

        expect {
          result = service.call
        }.to_not change(GithubAccount, :count)
        expect(result.data).to be_nil
        expect(result.status).to eq(BaseService::FAILURE)
      end
    end

    context 'when token is invalid' do
      before do
        allow(service).to receive(:valid_token?).and_return(false)
      end
      it 'should return failure' do
        result = nil

        expect {
          result = service.call
        }.to_not change(GithubAccount, :count)
        expect(result.data).to be_nil
        expect(result.status).to eq(BaseService::FAILURE)
      end
    end
  end
end
