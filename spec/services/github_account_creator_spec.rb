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
      end

      it 'should create a github account and associate it with the correct user' do
        result = nil
        expect {
          result = service.call }.to change { GithubAccount.count }.by(1).and change { user.reload.github_account }.from(nil)
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
    context 'when save fails' do
      let(:error) { 'test error' }
      let(:errors) { [error] }
      let(:github_account) { instance_double(GithubAccount) }

      before do
        allow(GithubAccount).to receive(:new).and_return(github_account)
        allow(github_account).to receive(:valid?).and_return(true)
        allow(service).to receive(:valid_token?).and_return(true)
        allow(github_account).to receive(:save).and_return(false)
        allow(github_account).to receive(:errors).and_return(error)
      end

      it 'should return failure and add errors' do
        result = nil

        expect {
          result = service.call
        }.to_not change(GithubAccount, :count)
        expect(result.data).to be_nil
        expect(result.status).to eq(BaseService::FAILURE)
        expect(result.errors).to eq(errors)
      end
    end
  end
end