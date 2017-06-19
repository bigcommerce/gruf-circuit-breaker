# coding: utf-8
# Copyright (c) 2017-present, BigCommerce Pty. Ltd. All rights reserved
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
# persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
# Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
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
