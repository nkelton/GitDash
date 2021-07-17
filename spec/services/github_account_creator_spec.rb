require 'rails_helper'

RSpec.describe GithubAccountCreator do
  let(:service) { described_class.new(params) }
  let(:user) { create(:user) }
  let(:params) do
    {
      username: username,
      token: token,
      user_id: user.id
    }
  end
  let(:token) { '123' }

  describe '.call' do
    context 'when params are valid' do
      let(:username) { 'Bob Smith' }
      it 'should create a github account and associate it with the correct user' do
        result = nil
        expect {
          result = service.call }.to change { GithubAccount.count }.by(1).and change { user.reload.github_account }.from(nil)
        expect(result.status).to eq(BaseService::SUCCESS)
      end
    end
    context 'when params are invalid' do
      let(:username) { nil }
      it 'should return failure' do
        result = service.call
        expect(result.status).to eq(BaseService::FAILURE)
      end
    end
    context 'when save fails' do
      let(:username) { 'Bob Smith' }
      let(:error) { 'test error' }
      let(:errors) { [error] }
      let(:github_account) { instance_double(GithubAccount) }

      before do
        allow(GithubAccount).to receive(:new).and_return(github_account)
        allow(github_account).to receive(:valid?).and_return(true)
        allow(github_account).to receive(:token?).and_return(true)
        allow(github_account).to receive(:save).and_return(false)
        allow(github_account).to receive(:errors).and_return(error)
      end

      it 'should return failure and add errors' do
        result = service.call
        expect(result.status).to eq(BaseService::FAILURE)
        expect(result.errors).to eq(errors)
      end
    end
  end
end
