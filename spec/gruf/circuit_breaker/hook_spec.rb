require 'spec_helper'

describe Gruf::CircuitBreaker::Hook do
  let(:service) { ThingService.new }
  let(:options) { {} }
  let(:signature) { 'get_thing' }
  let(:hook) { described_class.new(service, { circuit_breaker: options }) }

  describe '.options' do
    let(:options) { { abc: 'def' } }
    subject { hook.send(:options) }

    it 'should return circuit_breaker options' do
      expect(subject).to eq options
    end
  end

  describe '.service_key' do
    subject { hook.send(:service_key) }
    it 'should be the translated service class name' do
      expect(subject).to eq 'thing_service'
    end
  end

  describe '.method_key' do
    subject { hook.send(:method_key, signature) }
    it 'should return the service key and the method signature concatenated by a .' do
      expect(subject).to eq 'thing_service.get_thing'
    end
  end
end
