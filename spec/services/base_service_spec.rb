require 'rails_helper'

RSpec.describe BaseService do
  let(:service) { described_class.new }

  describe '.success' do
    let(:data) { 'testing' }
    it 'should set data and status from nil' do
      expect {
        service.success(data)
      }.to change { service.data }.from(nil).to(data).and change { service.status }.from(nil).to(BaseService::SUCCESS)
    end
  end

  describe '.failure' do
    let(:data) { 'testing' }
    it 'should set data and status from nil' do
      expect {
        service.failure(data)
      }.to change { service.data }.from(nil).to(data).and change { service.status }.from(nil).to(BaseService::FAILURE)
    end
  end

  describe '.add_error' do
    let(:error) { 'error' }
    it 'should add the error to internal errors' do
      expect {
        service.add_error(error)
      }.to change { service.errors.count }.from(0).to(1)
    end
  end

  describe '.add_errors' do
    let(:error) { ['error'] }
    it 'should add the errors to internal errors' do
      expect {
        service.add_error(error)
      }.to change { service.errors.count }.from(0).to(1)
    end
  end

  describe '.error_messages' do
    before { service.add_error(error) }

    context 'when error responds to `messages`' do
      let(:error_message) { 'test' }
      let(:error_messages) { [error_message] }

      let(:error) do
        spy.tap { |s| allow(s).to receive(:messages).and_return(error_message) }
      end

      it 'returns error message' do
        expect(service.error_messages).to eq(error_messages)
      end
    end

    context 'when error does not respond to `messages`' do
      let(:error) { 'test' }
      it 'returns empty array' do
        expect(service.error_messages).to be_empty
      end
    end

  end


end
