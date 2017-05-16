require 'spec_helper'

describe Gruf::CircuitBreaker do
  describe 'version' do
    it 'should have a version' do
      expect(Gruf::CircuitBreaker::VERSION).to be_a(String)
    end
  end
end
