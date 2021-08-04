require 'rails_helper'

RSpec.describe UserCreator do
  let(:service) { described_class.new(params) }
  let(:params) do
    {
      name: 'Bob',
      email: 'bob@gmail.com',
      encrypted_password: 'password'
    }
  end

  describe '.call' do
    context 'with valid params' do
      it 'should create a user and profile' do
        result = nil
        expect {
          result = service.call
        }.to change(User, :count).by(1).and change(Profile, :count).by(1)
        expect(result.status).to eq(BaseService::SUCCESS)
        expect(result.data).to be_a(User)
      end
    end
    context 'with invalid params' do
      let(:params) do
        {
          name: 'Bob'
        }
      end
      it 'should not create a user and profile' do
        result = nil
        expect {
          result = service.call
        }.to raise_error
      end
    end
  end

end
